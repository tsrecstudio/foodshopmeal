"""Generates M1 seed migrations: V003 (300 RF ingredients) and V004 (50 RF recipes).

Run from repo root:
    python3 tools/generate_m1_seeds.py

Invariants locked in M0:
  * grams_raw is per base serving, never stored for recipe nutrition;
  * KBZHU is always derived deterministically at read time (no stored nutrients).
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MIGRATIONS = ROOT / "db" / "migrations"


def load_ingredients() -> list[list[str]]:
    rows: list[list[str]] = []
    for part in ("a", "b", "c"):
        p = ROOT / "tools" / f"m1_ingredients_{part}.tsv"
        if not p.exists():
            continue
        for line in p.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split("|")
            if len(parts) < 11:
                continue
            rows.append([parts[0].strip()] + parts[1:11])
    return rows


def validate_row(row: list[str]) -> bool:
    try:
        kcal, p, f, c, fiber = (float(x) for x in row[2:7])
        dens = float(row[7])
        yld = float(row[8])
        waste = float(row[9])
    except ValueError:
        return False
    if kcal < 0 or p < 0 or f < 0 or c < 0 or fiber < 0:
        return False
    if kcal > 950:
        return False
    if p + f + c + fiber > 101.0:
        return False
    if dens <= 0 or dens > 2.5:
        return False
    if yld <= 0 or yld > 5.0:
        return False
    if waste < 0 or waste >= 1.0:
        return False
    return True


def synonyms_for(name: str, cat: str) -> list[str]:
    syns = {name.lower()}
    if name.endswith(" крупа"):
        syns.add(name[:-len(" крупа")].strip().lower())
    if cat == "fish":
        syns.add("рыба")
    if cat == "vegetables":
        syns.add("овощ")
    if cat == "fruits":
        syns.add("фрукт")
    for token in (" гечневая", " овсяная", " кукурузная", " пшеничная", " рисовая"):
        if token in name:
            syns.add(name.replace(token, "").strip().lower())
    return sorted(syns)


def tags_for(cat: str) -> list[str]:
    tags = {cat}
    if cat == "grains":
        tags.add("carb")
    if cat == "legumes":
        tags.add("plant_protein")
    if cat == "dairy":
        tags.add("calcium")
    if cat == "meat":
        tags.add("protein")
    if cat == "fish":
        tags.add("omega3")
    if cat == "vegetables":
        tags.add("fiber")
    if cat == "fruits":
        tags.add("fruit")
    if cat == "nuts":
        tags.add("fat")
    if cat == "seasonings":
        tags.add("seasoning")
    return sorted(tags)


def to_sql_array(values: list[str]) -> str:
    if not values:
        return "'{}'::text[]"
    inner = ", ".join("'%s'" % v for v in values)
    return "ARRAY[" + inner + "]"


def emit_v003(rows: list[list[str]]) -> str:
    lines = [
        "-- =====================================================================",
        "-- V003__seed_ingredients_rf_300.sql",
        "-- Stage M1: 300 base RF ingredients.",
        "-- Sources: Skurikhin / FGU tables (representative values).",
        "-- Nutrients are per 100 g of edible raw portion.",
        "-- =====================================================================",
        "",
        "INSERT INTO core.ingredients",
        "    (id, name, synonyms, category, kcal_per_100g, protein_per_100g, fat_per_100g,",
        "     carb_per_100g, fiber_per_100g, density_g_per_ml, yield_factor_cooked,",
        "     waste_factor, allergens, tags)",
        "VALUES",
    ]
    for i, r in enumerate(rows):
        (name, cat, kcal, p, fat, c, fiber, dens, yld, waste, allergens) = r[:11]
        syns = to_sql_array(synonyms_for(name, cat))
        tags = to_sql_array(tags_for(cat))
        al = to_sql_array([a for a in allergens.split(",") if a])
        vals = [
            "gen_random_uuid()",
            f"'{name}'",
            syns,
            f"'{cat}'",
            f"{kcal}",
            f"{p}",
            f"{fat}",
            f"{c}",
            f"{fiber}",
            f"{dens}",
            f"{yld}",
            f"{waste}",
            al,
            tags,
        ]
        lines.append("    (" + ", ".join(vals) + ")")
        if i < len(rows) - 1:
            lines.append("    ,")
    lines.append(";")
    lines.append("")
    return "\n".join(lines)


RECIPE_TEMPLATES: list[tuple] = []


def build_recipes() -> list[tuple]:
    recipes = []
    def add(title, tags, diff, tmin, equip, servings, steps, ingredients):
        recipes.append((title, tags, diff, tmin, equip, servings, steps, ingredients))

    add("Куриное филе на сковороде с отварной гречкой",
        ["lunch", "dinner", "high_protein"], "easy", 25, ["stove", "pan", "pot"], 2,
        [{"stepNo": 1, "text": "Промыть гечку, залить водой 1:2 и варить под крышкой.", "timerSec": 900},
         {"stepNo": 2, "text": "Отбелить и нарезать куриное филе.", "timerSec": 0},
         {"stepNo": 3, "text": "Посолить, обжарить на сковороде с маслом до готовности.", "timerSec": 360}],
        [("Гречневая крупа ядрица", "50", False, "base_grain"),
         ("Филе курицы", "150", False, "base_protein"),
         ("Морковь", "30", False, "base_veg"),
         ("Масло растительное", "10", False, None),
         ("Соль", "2", False, None)])

    add("Овсянка на молоке с ягодами",
        ["breakfast", "lowcal"], "easy", 8, ["pot", "blender"], 1,
        [{"stepNo": 1, "text": "Сварить овсянку на молоке.", "timerSec": 180},
         {"stepNo": 2, "text": "Добавить ягоды и ложку масла.", "timerSec": 0}],
        [("Хлопья овсяные", "40", False, "base_grain"),
         ("Молоко коровье 2,5%", "150", False, "base_dairy"),
         ("Клубника", "40", False, "base_fruit"),
         ("Мед", "10", False, None)])

    add("Творожные сырники",
        ["breakfast", "dessert", "protein"], "medium", 30, ["stove", "pan", "bowl"], 4,
        [{"stepNo": 1, "text": "Смешать творог, муку, яйцо и соль.", "timerSec": 120},
         {"stepNo": 2, "text": "Слепить лепёшки и варить на паровой сковороде.", "timerSec": 1200},
         {"stepNo": 3, "text": "Подать с вареньем.", "timerSec": 0}],
        [("Творог постный 0%", "300", False, "base_protein"),
         ("Яйца куриные", "2", False, "base_egg"),
         ("Пшеничная мука", "20", False, None),
         ("Мед", "30", False, None)])

    add("Бутерброды с ветчиной и сыром",
        ["breakfast", "lunch", "snack"], "easy", 7, ["plate", "knife"], 1,
        [{"stepNo": 1, "text": "Нарезать хлеб, ветчину и сыр.", "timerSec": 0},
         {"stepNo": 2, "text": "Собрать бутерброды.", "timerSec": 0}],
        [("Хлеб пшеничный", "50", False, "base_carb"),
         ("Ветчина", "40", False, "base_protein"),
         ("Сыр пармезан", "20", False, "base_dairy"),
         ("Масло сливочное 72,5%", "5", False, None)])

    add("Бирьяни с курицей",
        ["lunch", "dinner", "premium"], "hard", 75, ["stove", "pot", "pan"], 4,
        [{"stepNo": 1, "text": "Marinate chicken with spices.", "timerSec": 900},
         {"stepNo": 2, "text": "Cook rice with stock and saffron.", "timerSec": 1500},
         {"stepNo": 3, "text": "Layer chicken and rice, steam.", "timerSec": 600}],
        [("Рис длинный басмати", "200", False, "base_grain"),
         ("Филе курицы", "300", False, "base_protein"),
         ("Масло рапсовое", "15", False, None),
         ("Соль", "3", False, None),
         ("Перец чёрный молотый", "1", False, None)])

    add("Суп картофельный с кремом",
        ["lunch", "dinner", "comfort"], "easy", 40, ["pot", "blender"], 4,
        [{"stepNo": 1, "text": "Протушить картофель с луком и морковью.", "timerSec": 1200},
         {"stepNo": 2, "text": "Залить бульоном, проварить и блендерировать.", "timerSec": 600},
         {"stepNo": 3, "text": "Подавать с кремом и зеленью.", "timerSec": 0}],
        [("Картофель", "400", False, "base_veg"),
         ("Морковь", "80", False, "base_veg"),
         ("Лук репчатый", "40", False, "base_veg"),
         ("Масло сливочное 72,5%", "20", False, None),
         ("Укроп", "5", True, None)])

    add("Гречка с куриной грудкой и овощами",
        ["lunch", "dinner", "high_protein"], "easy", 25, ["stove", "pan", "pot"], 2,
        [{"stepNo": 1, "text": "Сварить гечку.", "timerSec": 900},
         {"stepNo": 2, "text": "Обжарить куриную грудку.", "timerSec": 360},
         {"stepNo": 3, "text": "Смешать с овощами.", "timerSec": 0}],
        [("Гречневая крупа ядрица", "60", False, "base_grain"),
         ("Куриная грудка", "180", False, "base_protein"),
         ("Морковь", "40", False, "base_veg"),
         ("Огурцы", "40", False, "base_veg"),
         ("Масло растительное", "10", False, None)])

    add("Яичница-глазунья",
        ["breakfast", "lunch", "quick"], "easy", 6, ["stove", "pan"], 1,
        [{"stepNo": 1, "text": "Разбить яйца в сковороду.", "timerSec": 0},
         {"stepNo": 2, "text": "Потушить под крышкой до затвердения.", "timerSec": 180},
         {"stepNo": 3, "text": "Посолить и подать с зеленью.", "timerSec": 0}],
        [("Яйца куриные", "2", False, "base_egg"),
         ("Укроп", "5", True, None),
         ("Масло сливочное 72,5%", "5", False, None),
         ("Соль", "1", False, None)])

    add("Запеканка картофельная",
        ["lunch", "dinner", "comfort"], "medium", 45, ["oven", "pan"], 4,
        [{"stepNo": 1, "text": "Нарезать картофель и сыр.", "timerSec": 0},
         {"stepNo": 2, "text": "Смешать с молоком и маслом.", "timerSec": 120},
         {"stepNo": 3, "text": "Запекать 30 минут.", "timerSec": 1800}],
        [("Картофель", "500", False, "base_veg"),
         ("Молоко коровье 3,2%", "150", False, "base_dairy"),
         ("Сыр пармезан", "40", False, "base_dairy"),
         ("Масло сливочное 72,5%", "30", False, None)])

    add("Рагу из свеклы и моркови",
        ["lunch", "dinner", "vegan"], "easy", 35, ["stove", "pot"], 4,
        [{"stepNo": 1, "text": "Нарезать свеклу и морковь.", "timerSec": 0},
         {"stepNo": 2, "text": "Тушить с маслом и луком.", "timerSec": 1200},
         {"stepNo": 3, "text": "Добавить соль и томатную пассату.", "timerSec": 300}],
        [("Свёкла", "200", False, "base_veg"),
         ("Морковь", "150", False, "base_veg"),
         ("Лук репчатый", "50", False, "base_veg"),
         ("Масло подсолнечное", "15", False, None),
         ("Томатная пассата", "50", False, None)])

    add("Пельмени домашние",
        ["lunch", "dinner", "traditional"], "medium", 40, ["stove", "pot", "plate"], 4,
        [{"stepNo": 1, "text": "Замесить тесто и нашинковать фарш.", "timerSec": 900},
         {"stepNo": 2, "text": "Слепить пельмени.", "timerSec": 900},
         {"stepNo": 3, "text": "Сварить в подсоленной воде.", "timerSec": 600}],
        [("Пшеничная мука", "200", False, "base_carb"),
         ("Филе свинины", "200", False, "base_protein"),
         ("Капуста белокочанная", "100", False, "base_veg"),
         ("Яйца куриные", "1", False, "base_egg"),
         ("Соль", "3", False, None)])

    add("Омлет с овощами",
        ["breakfast", "lunch", "veggie"], "easy", 10, ["stove", "pan", "bowl"], 2,
        [{"stepNo": 1, "text": "Взбить яйцы с молоком и солью.", "timerSec": 120},
         {"stepNo": 2, "text": "Нарезать овощи и обжарить.", "timerSec": 300},
         {"stepNo": 3, "text": "Залить яичной смесью и накрыть крышкой.", "timerSec": 300}],
        [("Яйца куриные", "4", False, "base_egg"),
         ("Молоко коровье 2,5%", "60", False, "base_dairy"),
         ("Перец болгарский", "60", False, "base_veg"),
         ("Лук репчатый", "30", False, "base_veg"),
         ("Масло растительное", "10", False, None)])

    add("Салат из огурцов и свеклы",
        ["lunch", "side", "vegan", "lowcal"], "easy", 10, ["bowl", "knife"], 2,
        [{"stepNo": 1, "text": "Нарезать огурцы и свеклу.", "timerSec": 0},
         {"stepNo": 2, "text": "Смешать с маслом и солью.", "timerSec": 0}],
        [("Огурцы", "150", False, "base_veg"),
         ("Свёкла", "100", False, "base_veg"),
         ("Морковь", "50", False, "base_veg"),
         ("Укроп", "5", True, None),
         ("Соль", "2", False, None)])

    add("Куриный суп-лапша",
        ["lunch", "dinner", "comfort"], "easy", 45, ["pot", "stove"], 4,
        [{"stepNo": 1, "text": "Сварить куриный бульон.", "timerSec": 1800},
         {"stepNo": 2, "text": "Добавить лапшу и овощи.", "timerSec": 600},
         {"stepNo": 3, "text": "Подавать со зеленью.", "timerSec": 0}],
        [("Филе курицы", "300", False, "base_protein"),
         ("Лапша тонкая", "100", False, "base_carb"),
         ("Морковь", "60", False, "base_veg"),
         ("Лук зелёный", "10", True, None),
         ("Соль", "3", False, None)])

    add("Чечевичный суп с овощами",
        ["lunch", "dinner", "vegan", "fiber"], "easy", 35, ["pot", "stove"], 4,
        [{"stepNo": 1, "text": "Промыть чечевицу.", "timerSec": 0},
         {"stepNo": 2, "text": "Сварить с овощами и томатной пассатой.", "timerSec": 1500},
         {"stepNo": 3, "text": "Подать со сметаной.", "timerSec": 0}],
        [("Чечевица красная", "150", False, "base_protein"),
         ("Лук репчатый", "50", False, "base_veg"),
         ("Морковь", "60", False, "base_veg"),
         ("Томатная пассата", "80", False, None),
         ("Сметана 10%", "30", True, None)])

    add("Гречка с индейкой",
        ["lunch", "dinner", "high_protein"], "easy", 30, ["stove", "pan", "pot"], 2,
        [{"stepNo": 1, "text": "Сварить гечку.", "timerSec": 900},
         {"stepNo": 2, "text": "Обжарить филе индейки.", "timerSec": 360},
         {"stepNo": 3, "text": "Смешать и подать.", "timerSec": 0}],
        [("Гречневая крупа ядрица", "60", False, "base_grain"),
         ("Филе индейки", "150", False, "base_protein"),
         ("Масло растительное", "10", False, None),
         ("Соль", "2", False, None)])

    add("Картофель фри",
        ["snack", "lunch", "comfort"], "easy", 25, ["stove", "pot", "baker"], 2,
        [{"stepNo": 1, "text": "Срезать картофель и замочить.", "timerSec": 600},
         {"stepNo": 2, "text": "Запекать в духовке с маслом.", "timerSec": 1200}],
        [("Картофель", "400", False, "base_veg"),
         ("Масло растительное", "20", False, None),
         ("Соль", "3", False, None)])

    add("Салат из цикория и гранатовой кислоты",
        ["lunch", "side", "lowcal"], "easy", 8, ["bowl", "knife"], 2,
        [{"stepNo": 1, "text": "Нарезать цикорий.", "timerSec": 0},
         {"stepNo": 2, "text": "Добавить гранатовый соус и масло.", "timerSec": 0}],
        [("Сельдерей", "80", False, "base_veg"),
         ("Яблоки антоновские", "80", False, "base_fruit"),
         ("Масло оливковое", "10", False, None),
         ("Уксус", "10", False, None)])

    add("Какао с молоком",
        ["breakfast", "snack", "comfort"], "easy", 5, ["pot"], 1,
        [{"stepNo": 1, "text": "Вскипятить молоко.", "timerSec": 180},
         {"stepNo": 2, "text": "Добавить какао и подождать.", "timerSec": 60}],
        [("Молоко коровье 3,2%", "200", False, "base_dairy"),
         ("Сахар", "15", False, None),
         ("Какао-порошок", "10", False, None)])

    add("Торт «Саратов»",
        ["dessert", "comfort"], "hard", 90, ["oven", "pan"], 8,
        [{"stepNo": 1, "text": "Замесить бисквит.", "timerSec": 300},
         {"stepNo": 2, "text": "Выпести коржи.", "timerSec": 2400},
         {"stepNo": 3, "text": "Смазать кремом и оформить.", "timerSec": 1200}],
        [("Пшеничная мука", "300", False, "base_carb"),
         ("Яйца куриные", "6", False, "base_egg"),
         ("Сахар", "250", False, None),
         ("Масло сливочное 72,5%", "150", False, None)])

    add("Птичфе «Медовый»",
        ["dessert", "comfort"], "medium", 60, ["oven", "pan"], 6,
        [{"stepNo": 1, "text": "Замесить тесто с медом и орехами.", "timerSec": 600},
         {"stepNo": 2, "text": "Выпекать 25 минут.", "timerSec": 1500}],
        [("Пшеничная мука", "200", False, "base_carb"),
         ("Грецкие орещи", "100", False, "base_fat"),
         ("Мед", "80", False, None),
         ("Яйца куриные", "3", False, "base_egg")])

    add("Вафля тяжёлая",
        ["breakfast", "dessert"], "easy", 10, ["wafel iron"], 2,
        [{"stepNo": 1, "text": "Смешать тесто.", "timerSec": 120},
         {"stepNo": 2, "text": "Испечать вафлю.", "timerSec": 600}],
        [("Пшеничная мука", "150", False, "base_carb"),
         ("Яйца куриные", "2", False, "base_egg"),
         ("Молоко коровье 3,2%", "100", False, "base_dairy"),
         ("Масло сливочное 72,5%", "50", False, None)])

    add("Фланк-стейк",
        ["lunch", "dinner", "premium"], "medium", 15, ["stove", "pan"], 2,
        [{"stepNo": 1, "text": "Обжарить мясо с солью и перцем.", "timerSec": 600},
         {"stepNo": 2, "text": "Обжарить в гриле.", "timerSec": 300}],
        [("Говядина подоскасник", "300", False, "base_protein"),
         ("Масло подсолнечное", "10", False, None),
         ("Перец чёрный молотый", "2", False, None)])

    add("Шашлык из свинины",
        ["lunch", "dinner", "grill"], "medium", 30, ["grill", "bowl"], 4,
        [{"stepNo": 1, "text": "Намариновать мясо в луке и соли.", "timerSec": 1800},
         {"stepNo": 2, "text": "Зажечь огонь и жарить.", "timerSec": 900}],
        [("Свинина лопатка", "500", False, "base_protein"),
         ("Лук репчатый", "100", False, "base_veg"),
         ("Соль", "5", False, None)])

    add("Рыба на гриле с зеленью",
        ["lunch", "dinner", "fish"], "medium", 20, ["grill", "pan"], 2,
        [{"stepNo": 1, "text": "Marinate fish with butter and herbs.", "timerSec": 300},
         {"stepNo": 2, "text": "Grill for 8 minutes per side.", "timerSec": 960}],
        [("Филе лосося", "200", False, "base_protein"),
         ("Масло сливочное 72,5%", "20", False, None),
         ("Петрушка", "5", True, None),
         ("Соль", "2", False, None)])

    add("Креветки с рисом",
        ["lunch", "dinner", "seafood"], "easy", 25, ["stove", "pan", "pot"], 2,
        [{"stepNo": 1, "text": "Сварить рис.", "timerSec": 900},
         {"stepNo": 2, "text": "Обжарить креветки с маслом.", "timerSec": 300},
         {"stepNo": 3, "text": "Смешать и подать.", "timerSec": 0}],
        [("Креветки мерклэн", "200", False, "base_protein"),
         ("Рис длинный басмати", "100", False, "base_grain"),
         ("Масло рапсовое", "10", False, None)])

    add("Запечённый картофель с бобами",
        ["lunch", "dinner", "vegan"], "easy", 50, ["oven", "pan"], 4,
        [{"stepNo": 1, "text": "Сварить картофель.", "timerSec": 1200},
         {"stepNo": 2, "text": "Запекать с горохом.", "timerSec": 1200}],
        [("Картофель", "500", False, "base_veg"),
         ("Горох морской", "100", False, "base_protein"),
         ("Масло растительное", "20", False, None)])

    add("Мясная нарезка",
        ["lunch", "snack"], "easy", 5, ["plate", "knife"], 2,
        [{"stepNo": 1, "text": "Нарезать ветчину и сыр.", "timerSec": 0},
         {"stepNo": 2, "text": "Подать на тарелке.", "timerSec": 0}],
        [("Ветчина", "100", False, "base_protein"),
         ("Сыр пармезан", "50", False, "base_dairy"),
         ("Хлеб пшеничный", "50", False, "base_carb")])

    add("Творожная запеканка",
        ["breakfast", "dessert", "protein"], "medium", 40, ["oven", "pan"], 4,
        [{"stepNo": 1, "text": "Смешать творог, муку, яйцо и изюм.", "timerSec": 300},
         {"stepNo": 2, "text": "Выпекать 20 минут.", "timerSec": 1200}],
        [("Творог постный 0%", "400", False, "base_protein"),
         ("Яйца куриные", "3", False, "base_egg"),
         ("Пшеничная мука", "40", False, None),
         ("Сахар", "50", False, None)])

    add("Макароны по-флорентийски",
        ["lunch", "dinner"], "easy", 30, ["pot", "stove"], 2,
        [{"stepNo": 1, "text": "Сварить макароны.", "timerSec": 600},
         {"stepNo": 2, "text": "Приготовить соус из чеснока и масла.", "timerSec": 300}],
        [("Макароны", "100", False, "base_carb"),
         ("Чеснок", "20", False, "base_veg"),
         ("Масло оливковое", "20", False, None),
         ("Перец чёрный молотый", "1", False, None)])

    add("Салат из моркови и черники",
        ["lunch", "side", "fruit"], "easy", 8, ["bowl", "knife"], 2,
        [{"stepNo": 1, "text": "Натереть морковь.", "timerSec": 0},
         {"stepNo": 2, "text": "Смешать с черникой и масло.", "timerSec": 0}],
        [("Морковь", "150", False, "base_veg"),
         ("Черника", "50", False, "base_fruit"),
         ("Масло оливковое", "10", False, None)])

    add("Овсянка с ягодами и горстью",
        ["breakfast", "protein"], "easy", 8, ["pot", "blender"], 1,
        [{"stepNo": 1, "text": "Сварить овсянку на молоке.", "timerSec": 180},
         {"stepNo": 2, "text": "Добавить горсть семян и ягоды.", "timerSec": 0}],
        [("Хлопья овсяные", "40", False, "base_grain"),
         ("Молоко коровье 3,2%", "150", False, "base_dairy"),
         ("Горсть семян льна", "20", False, "base_fat"),
         ("Клубника", "40", False, "base_fruit")])

    add("Суп из гороха с зеленью",
        ["lunch", "dinner", "vegan"], "easy", 30, ["pot", "stove"], 4,
        [{"stepNo": 1, "text": "Сварить горох.", "timerSec": 1200},
         {"stepNo": 2, "text": "Протереть и подавать.", "timerSec": 0}],
        [("Горох морской", "150", False, "base_protein"),
         ("Морковь", "80", False, "base_veg"),
         ("Укроп", "5", True, None),
         ("Соль", "3", False, None)])

    add("Гречка с сосиской",
        ["lunch", "dinner", "cheap"], "easy", 20, ["stove", "pan"], 1,
        [{"stepNo": 1, "text": "Сварить гечку.", "timerSec": 900},
         {"stepNo": 2, "text": "Обжарить сосиски.", "timerSec": 300}],
        [("Гечневая крупа ядрица", "50", False, "base_grain"),
         ("Сосиски куриные", "100", False, "base_protein"),
         ("Масло растительное", "10", False, None)])

    add("Запечённый брокколи с сыром",
        ["lunch", "side", "vegetable"], "easy", 25, ["oven", "pan"], 2,
        [{"stepNo": 1, "text": "Нарезать брокколи.", "timerSec": 0},
         {"stepNo": 2, "text": "Посыпать сыром и запечь.", "timerSec": 900}],
        [("Капуста броколистная", "300", False, "base_veg"),
         ("Сыр пармезан", "30", False, "base_dairy"),
         ("Масло оливковое", "15", False, None)])

    add("Суп из чечевицы с овощами",
        ["lunch", "dinner", "vegan", "fiber"], "easy", 40, ["pot", "stove"], 4,
        [{"stepNo": 1, "text": "Сварить чечевицу с овощами.", "timerSec": 1800},
         {"stepNo": 2, "text": "Протереть.", "timerSec": 0}],
        [("Чечевица зелёная", "150", False, "base_protein"),
         ("Лук репчатый", "60", False, "base_veg"),
         ("Морковь", "80", False, "base_veg"),
         ("Соль", "3", False, None)])

    add("Филе утки с вишнёй",
        ["lunch", "dinner", "premium"], "hard", 45, ["stove", "pan"], 2,
        [{"stepNo": 1, "text": "Обжарить филе утки.", "timerSec": 600},
         {"stepNo": 2, "text": "Приготовить соус из вишни.", "timerSec": 300}],
        [("Филе утки", "200", False, "base_protein"),
         ("Вишня", "100", False, "base_fruit"),
         ("Масло сливочное 72,5%", "20", False, None)])

    add("Картофельное пюре",
        ["side", "comfort"], "easy", 25, ["pot", "stove"], 4,
        [{"stepNo": 1, "text": "Сварить картофель.", "timerSec": 1200},
         {"stepNo": 2, "text": "Растереть с маслом и молоком.", "timerSec": 0}],
        [("Картофель", "500", False, "base_veg"),
         ("Молоко коровье 2,5%", "100", False, "base_dairy"),
         ("Масло сливочное 72,5%", "30", False, None),
         ("Соль", "3", False, None)])

    add("Яичный суфле",
        ["breakfast", "dessert"], "medium", 30, ["oven", "bowl"], 2,
        [{"stepNo": 1, "text": "Взбить белки.", "timerSec": 120},
         {"stepNo": 2, "text": "Запечь в духовке.", "timerSec": 900}],
        [("Яйца куриные", "4", False, "base_egg"),
         ("Молоко коровье 2,5%", "50", False, "base_dairy"),
         ("Сахар", "20", False, None)])

    add("Салат из огурцов",
        ["lunch", "side", "lowcal"], "easy", 8, ["bowl", "knife"], 2,
        [{"stepNo": 1, "text": "Нарезать огурцы.", "timerSec": 0},
         {"stepNo": 2, "text": "Смешать с маслом и солью.", "timerSec": 0}],
        [("Огурцы", "200", False, "base_veg"),
         ("Укроп", "5", True, None),
         ("Масло подсолнечное", "15", False, None)])

    add("Филе семги на сковороде",
        ["lunch", "dinner", "fish"], "medium", 15, ["stove", "pan"], 2,
        [{"stepNo": 1, "text": "Marinate fish with oil and herbs.", "timerSec": 300},
         {"stepNo": 2, "text": "Обжарить 5 минут.", "timerSec": 300}],
        [("Филе семги", "200", False, "base_protein"),
         ("Масло оливковое", "15", False, None),
         ("Петрушка", "5", True, None)])

    add("Гречка с хлебом",
        ["lunch", "dinner", "traditional"], "easy", 20, ["stove", "pan"], 2,
        [{"stepNo": 1, "text": "Сварить гечку.", "timerSec": 900},
         {"stepNo": 2, "text": "Подать с хлебом.", "timerSec": 0}],
        [("Гечневая крупа ядрица", "60", False, "base_grain"),
         ("Хлеб пшеничный", "50", False, "base_carb"),
         ("Соль", "2", False, None)])

    add("Запека из овощей с яйцами",
        ["lunch", "dinner", "vegetable"], "easy", 35, ["oven", "pan"], 4,
        [{"stepNo": 1, "text": "Смешать овощи и яйца.", "timerSec": 300},
         {"stepNo": 2, "text": "Запекать 25 минут.", "timerSec": 1500}],
        [("Капуста белокочанная", "200", False, "base_veg"),
         ("Яйца куриные", "4", False, "base_egg"),
         ("Морковь", "100", False, "base_veg"),
         ("Сметана 10%", "50", False, "base_dairy")])

    add("Хумус с лавашом",
        ["lunch", "snack", "vegan"], "easy", 15, ["blender", "plate"], 2,
        [{"stepNo": 1, "text": "Смешать горох, чеснок и масло.", "timerSec": 300},
         {"stepNo": 2, "text": "Подать с лавашом.", "timerSec": 0}],
        [("Горох морской", "200", False, "base_protein"),
         ("Чеснок", "15", False, "base_veg"),
         ("Масло оливковое", "30", False, None),
         ("Соль", "3", False, None)])

    add("Творожок с горстью",
        ["breakfast", "protein"], "easy", 5, ["bowl"], 1,
        [{"stepNo": 1, "text": "Смешать творог и горсть.", "timerSec": 0},
         {"stepNo": 2, "text": "Подать с морковным соком.", "timerSec": 0}],
        [("Творог постный 0%", "150", False, "base_protein"),
         ("Горсть семян подсолнуха", "20", False, "base_fat"),
         ("Морковный сок", "100", False, "base_veg")])

    add("Салат из пекинской капусты",
        ["lunch", "side", "lowcal"], "easy", 8, ["bowl", "knife"], 2,
        [{"stepNo": 1, "text": "Нашинковать капусту.", "timerSec": 0},
         {"stepNo": 2, "text": "Смешать с уксусом и маслом.", "timerSec": 0}],
        [("Капуста пекинская", "200", False, "base_veg"),
         ("Уксус", "10", False, None),
         ("Масло подсолнечное", "15", False, None)])

    add("Филе трески на сковороде",
        ["lunch", "dinner", "fish"], "easy", 15, ["stove", "pan"], 2,
        [{"stepNo": 1, "text": "Marinate fish with oil and herbs.", "timerSec": 300},
         {"stepNo": 2, "text": "Обжарить 5 минут.", "timerSec": 300}],
        [("Филе трески", "200", False, "base_protein"),
         ("Масло растительное", "15", False, None),
         ("Соль", "2", False, None)])

    add("Торт «Фундук»",
        ["dessert", "comfort"], "hard", 90, ["oven", "pan"], 8,
        [{"stepNo": 1, "text": "Замесить тесто с фундуком.", "timerSec": 600},
         {"stepNo": 2, "text": "Выпекать 30 минут.", "timerSec": 1800}],
        [("Пшеничная мука", "250", False, "base_carb"),
         ("Грецкие орещи", "150", False, "base_fat"),
         ("Яйца куриные", "5", False, "base_egg"),
         ("Сахар", "200", False, None)])

    add("Картофель с горохом",
        ["lunch", "dinner", "vegan"], "easy", 25, ["stove", "pot"], 2,
        [{"stepNo": 1, "text": "Сварить картофель.", "timerSec": 1200},
         {"stepNo": 2, "text": "Смешать с горохом.", "timerSec": 0}],
        [("Картофель", "300", False, "base_veg"),
         ("Горох морской", "100", False, "base_protein"),
         ("Масло растительное", "15", False, None)])

    add("Яичница",
        ["breakfast", "lunch"], "easy", 6, ["stove", "pan"], 1,
        [{"stepNo": 1, "text": "Разбить яйца.", "timerSec": 0},
         {"stepNo": 2, "text": "Потушить под крышкой.", "timerSec": 180}],
        [("Яйца куриные", "2", False, "base_egg"),
         ("Укроп", "5", True, None),
         ("Масло сливочное 72,5%", "5", False, None)])

    add("Салат из огурцов и редиса",
        ["lunch", "side", "vegan"], "easy", 8, ["bowl", "knife"], 2,
        [{"stepNo": 1, "text": "Нарезать огурцы и редис.", "timerSec": 0},
         {"stepNo": 2, "text": "Смешать с маслом и солью.", "timerSec": 0}],
        [("Огурцы", "150", False, "base_veg"),
         ("Редис", "50", False, "base_veg"),
         ("Укроп", "5", True, None),
         ("Соль", "2", False, None)])

    add("Филе свинины с яблоком",
        ["lunch", "dinner", "premium"], "medium", 30, ["stove", "pan"], 2,
        [{"stepNo": 1, "text": "Обжарить мясо.", "timerSec": 600},
         {"stepNo": 2, "text": "Приготовить соус из яблока.", "timerSec": 300}],
        [("Филе свинины", "250", False, "base_protein"),
         ("Яблоки антоновские", "100", False, "base_fruit"),
         ("Масло подсолнечное", "15", False, None)])

    add("Творожное пирожное",
        ["dessert", "comfort"], "medium", 40, ["oven", "pan"], 4,
        [{"stepNo": 1, "text": "Замесить тесто.", "timerSec": 600},
         {"stepNo": 2, "text": "Выпекать 20 минут.", "timerSec": 1200}],
        [("Творог постный 0%", "300", False, "base_protein"),
         ("Пшеничная мука", "150", False, "base_carb"),
         ("Яйца куриные", "3", False, "base_egg"),
         ("Сахар", "50", False, None)])

    add("Запечённый лук с сыром",
        ["side", "comfort"], "easy", 25, ["oven", "pan"], 2,
        [{"stepNo": 1, "text": "Нарезать лук.", "timerSec": 0},
         {"stepNo": 2, "text": "Посыпать сыром и запечь.", "timerSec": 900}],
        [("Лук репчатый", "300", False, "base_veg"),
         ("Сыр пармезан", "30", False, "base_dairy"),
         ("Масло оливковое", "15", False, None)])

    add("Салат из гранатовой кислоты",
        ["lunch", "side", "lowcal"], "easy", 8, ["bowl", "knife"], 2,
        [{"stepNo": 1, "text": "Нарезать гранатную кислоту.", "timerSec": 0},
         {"stepNo": 2, "text": "Смешать с маслом и солью.", "timerSec": 0}],
        [("Сельдерей", "100", False, "base_veg"),
         ("Масло оливковое", "15", False, None),
         ("Соль", "2", False, None)])

    add("Творог с изюмом",
        ["breakfast", "protein"], "easy", 5, ["bowl"], 1,
        [{"stepNo": 1, "text": "Смешать творог и изюм.", "timerSec": 0},
         {"stepNo": 2, "text": "Подать с горстью.", "timerSec": 0}],
        [("Творог постный 0%", "150", False, "base_protein"),
         ("Горсть семян льна", "20", False, "base_fat")])

    add("Торт «Вафля»",
        ["dessert", "comfort"], "medium", 45, ["oven", "pan"], 6,
        [{"stepNo": 1, "text": "Замесить тесто.", "timerSec": 300},
         {"stepNo": 2, "text": "Выпекать 25 минут.", "timerSec": 1500}],
        [("Пшеничная мука", "250", False, "base_carb"),
         ("Яйца куриные", "4", False, "base_egg"),
         ("Сахар", "100", False, None),
         ("Масло сливочное 72,5%", "100", False, None)])

    return recipes


def emit_v004(recipes: list[tuple]) -> str:
    lines = [
        "-- =====================================================================",
        "-- V004__seed_recipes_rf_50.sql",
        "-- Stage M1: 50 base RF recipes.",
        "-- Recipes never store nutrients; computed at read time from ingredients.",
        "-- =====================================================================",
        "",
        "INSERT INTO core.recipes (id, title, steps, time_min, equipment, servings, tags, difficulty)",
        "VALUES",
    ]
    first = True
    for title, tags, diff, tmin, equip, servings, steps, ingredients in recipes:
        if not first:
            lines.append("    ,")
        first = False
        lines.append("    (gen_random_uuid(),")
        lines.append(f"        '{title}',")
        steps_json = json.dumps(steps, ensure_ascii=False, separators=(",", ":"))
        lines.append(f"        '{steps_json}'::jsonb,")
        lines.append(f"        {tmin},")
        eq_arr = to_sql_array(equip)
        lines.append(f"        {eq_arr},")
        lines.append(f"        {servings},")
        tags_arr = to_sql_array(tags)
        lines.append(f"        {tags_arr},")
        lines.append(f"        '{diff}'")
    lines[-1] = lines[-1] + ")"
    lines.append(";")
    # recipe_ingredients: explicit subqueries (names unique in ingredients)
    lines.append("")
    lines.append("-- Recipe-ingredient links (grams_raw per base serving)")
    lines.append("INSERT INTO core.recipe_ingredients (recipe_id, ingredient_id, grams_raw, optional, substitution_group)")
    lines.append("VALUES")
    all_rows = []
    for title, tags, diff, tmin, equip, servings, steps, ingredients in recipes:
        for name, grams, optional, sub in ingredients:
            sub_sql = "NULL" if sub is None else f"'{sub}'"
            all_rows.append(
                f"((SELECT id FROM core.recipes WHERE title = '{title}'), "
                f"(SELECT id FROM core.ingredients WHERE name = '{name}'), "
                f"{grams}::numeric, {str(optional).lower()}, {sub_sql})"
            )
    for i, row in enumerate(all_rows):
        lines.append("    " + row)
        if i < len(all_rows) - 1:
            lines.append("    ,")
    lines.append(";")
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    rows = load_ingredients()
    seen: dict[str, list[str]] = {}
    for r in rows:
        if not validate_row(r):
            continue
        seen.setdefault(r[0], r)
    unique = list(seen.values())
    if len(unique) < 300:
        raise SystemExit(f"ERROR: only {len(unique)} valid unique ingredients")
    final = unique[:300]
    recipes = build_recipes()[:50]
    if len(recipes) != 50:
        raise SystemExit(f"ERROR: got {len(recipes)} recipes, expected 50")
    v003 = emit_v003(final)
    v004 = emit_v004(recipes)
    MIGRATIONS.mkdir(parents=True, exist_ok=True)
    (MIGRATIONS / "V003__seed_ingredients_rf_300.sql").write_text(v003, encoding="utf-8")
    (MIGRATIONS / "V004__seed_recipes_rf_50.sql").write_text(v004, encoding="utf-8")
    print(f"Wrote V003 with {len(final)} ingredients")
    print(f"Wrote V004 with {len(recipes)} recipes")
    return 0


if __name__ == "__main__":
    sys.exit(main())
