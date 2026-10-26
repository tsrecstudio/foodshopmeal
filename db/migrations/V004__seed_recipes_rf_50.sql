-- =====================================================================
-- V004__seed_recipes_rf_50.sql
-- Stage M1: 50 base RF recipes.
-- Recipes never store nutrients; computed at read time from ingredients.
-- =====================================================================

INSERT INTO core.recipes (id, title, steps, time_min, equipment, servings, tags, difficulty)
VALUES
    (gen_random_uuid(),
        'Куриное филе на сковороде с отварной гречкой',
        '[{"stepNo":1,"text":"Промыть гечку, залить водой 1:2 и варить под крышкой.","timerSec":900},{"stepNo":2,"text":"Отбелить и нарезать куриное филе.","timerSec":0},{"stepNo":3,"text":"Посолить, обжарить на сковороде с маслом до готовности.","timerSec":360}]'::jsonb,
        25,
        {"stove", "pan", "pot"},
        2,
        {"lunch", "dinner", "high_protein"},
        'easy'
    ,
    (gen_random_uuid(),
        'Овсянка на молоке с ягодами',
        '[{"stepNo":1,"text":"Сварить овсянку на молоке.","timerSec":180},{"stepNo":2,"text":"Добавить ягоды и ложку масла.","timerSec":0}]'::jsonb,
        8,
        {"pot", "blender"},
        1,
        {"breakfast", "lowcal"},
        'easy'
    ,
    (gen_random_uuid(),
        'Творожные сырники',
        '[{"stepNo":1,"text":"Смешать творог, муку, яйцо и соль.","timerSec":120},{"stepNo":2,"text":"Слепить лепёшки и варить на паровой сковороде.","timerSec":1200},{"stepNo":3,"text":"Подать с вареньем.","timerSec":0}]'::jsonb,
        30,
        {"stove", "pan", "bowl"},
        4,
        {"breakfast", "dessert", "protein"},
        'medium'
    ,
    (gen_random_uuid(),
        'Бутерброды с ветчиной и сыром',
        '[{"stepNo":1,"text":"Нарезать хлеб, ветчину и сыр.","timerSec":0},{"stepNo":2,"text":"Собрать бутерброды.","timerSec":0}]'::jsonb,
        7,
        {"plate", "knife"},
        1,
        {"breakfast", "lunch", "snack"},
        'easy'
    ,
    (gen_random_uuid(),
        'Бирьяни с курицей',
        '[{"stepNo":1,"text":"Marinate chicken with spices.","timerSec":900},{"stepNo":2,"text":"Cook rice with stock and saffron.","timerSec":1500},{"stepNo":3,"text":"Layer chicken and rice, steam.","timerSec":600}]'::jsonb,
        75,
        {"stove", "pot", "pan"},
        4,
        {"lunch", "dinner", "premium"},
        'hard'
    ,
    (gen_random_uuid(),
        'Суп картофельный с кремом',
        '[{"stepNo":1,"text":"Протушить картофель с луком и морковью.","timerSec":1200},{"stepNo":2,"text":"Залить бульоном, проварить и блендерировать.","timerSec":600},{"stepNo":3,"text":"Подавать с кремом и зеленью.","timerSec":0}]'::jsonb,
        40,
        {"pot", "blender"},
        4,
        {"lunch", "dinner", "comfort"},
        'easy'
    ,
    (gen_random_uuid(),
        'Гречка с куриной грудкой и овощами',
        '[{"stepNo":1,"text":"Сварить гечку.","timerSec":900},{"stepNo":2,"text":"Обжарить куриную грудку.","timerSec":360},{"stepNo":3,"text":"Смешать с овощами.","timerSec":0}]'::jsonb,
        25,
        {"stove", "pan", "pot"},
        2,
        {"lunch", "dinner", "high_protein"},
        'easy'
    ,
    (gen_random_uuid(),
        'Яичница-глазунья',
        '[{"stepNo":1,"text":"Разбить яйца в сковороду.","timerSec":0},{"stepNo":2,"text":"Потушить под крышкой до затвердения.","timerSec":180},{"stepNo":3,"text":"Посолить и подать с зеленью.","timerSec":0}]'::jsonb,
        6,
        {"stove", "pan"},
        1,
        {"breakfast", "lunch", "quick"},
        'easy'
    ,
    (gen_random_uuid(),
        'Запеканка картофельная',
        '[{"stepNo":1,"text":"Нарезать картофель и сыр.","timerSec":0},{"stepNo":2,"text":"Смешать с молоком и маслом.","timerSec":120},{"stepNo":3,"text":"Запекать 30 минут.","timerSec":1800}]'::jsonb,
        45,
        {"oven", "pan"},
        4,
        {"lunch", "dinner", "comfort"},
        'medium'
    ,
    (gen_random_uuid(),
        'Рагу из свеклы и моркови',
        '[{"stepNo":1,"text":"Нарезать свеклу и морковь.","timerSec":0},{"stepNo":2,"text":"Тушить с маслом и луком.","timerSec":1200},{"stepNo":3,"text":"Добавить соль и томатную пассату.","timerSec":300}]'::jsonb,
        35,
        {"stove", "pot"},
        4,
        {"lunch", "dinner", "vegan"},
        'easy'
    ,
    (gen_random_uuid(),
        'Пельмени домашние',
        '[{"stepNo":1,"text":"Замесить тесто и нашинковать фарш.","timerSec":900},{"stepNo":2,"text":"Слепить пельмени.","timerSec":900},{"stepNo":3,"text":"Сварить в подсоленной воде.","timerSec":600}]'::jsonb,
        40,
        {"stove", "pot", "plate"},
        4,
        {"lunch", "dinner", "traditional"},
        'medium'
    ,
    (gen_random_uuid(),
        'Омлет с овощами',
        '[{"stepNo":1,"text":"Взбить яйцы с молоком и солью.","timerSec":120},{"stepNo":2,"text":"Нарезать овощи и обжарить.","timerSec":300},{"stepNo":3,"text":"Залить яичной смесью и накрыть крышкой.","timerSec":300}]'::jsonb,
        10,
        {"stove", "pan", "bowl"},
        2,
        {"breakfast", "lunch", "veggie"},
        'easy'
    ,
    (gen_random_uuid(),
        'Салат из огурцов и свеклы',
        '[{"stepNo":1,"text":"Нарезать огурцы и свеклу.","timerSec":0},{"stepNo":2,"text":"Смешать с маслом и солью.","timerSec":0}]'::jsonb,
        10,
        {"bowl", "knife"},
        2,
        {"lunch", "side", "vegan", "lowcal"},
        'easy'
    ,
    (gen_random_uuid(),
        'Куриный суп-лапша',
        '[{"stepNo":1,"text":"Сварить куриный бульон.","timerSec":1800},{"stepNo":2,"text":"Добавить лапшу и овощи.","timerSec":600},{"stepNo":3,"text":"Подавать со зеленью.","timerSec":0}]'::jsonb,
        45,
        {"pot", "stove"},
        4,
        {"lunch", "dinner", "comfort"},
        'easy'
    ,
    (gen_random_uuid(),
        'Чечевичный суп с овощами',
        '[{"stepNo":1,"text":"Промыть чечевицу.","timerSec":0},{"stepNo":2,"text":"Сварить с овощами и томатной пассатой.","timerSec":1500},{"stepNo":3,"text":"Подать со сметаной.","timerSec":0}]'::jsonb,
        35,
        {"pot", "stove"},
        4,
        {"lunch", "dinner", "vegan", "fiber"},
        'easy'
    ,
    (gen_random_uuid(),
        'Гречка с индейкой',
        '[{"stepNo":1,"text":"Сварить гечку.","timerSec":900},{"stepNo":2,"text":"Обжарить филе индейки.","timerSec":360},{"stepNo":3,"text":"Смешать и подать.","timerSec":0}]'::jsonb,
        30,
        {"stove", "pan", "pot"},
        2,
        {"lunch", "dinner", "high_protein"},
        'easy'
    ,
    (gen_random_uuid(),
        'Картофель фри',
        '[{"stepNo":1,"text":"Срезать картофель и замочить.","timerSec":600},{"stepNo":2,"text":"Запекать в духовке с маслом.","timerSec":1200}]'::jsonb,
        25,
        {"stove", "pot", "baker"},
        2,
        {"snack", "lunch", "comfort"},
        'easy'
    ,
    (gen_random_uuid(),
        'Салат из цикория и гранатовой кислоты',
        '[{"stepNo":1,"text":"Нарезать цикорий.","timerSec":0},{"stepNo":2,"text":"Добавить гранатовый соус и масло.","timerSec":0}]'::jsonb,
        8,
        {"bowl", "knife"},
        2,
        {"lunch", "side", "lowcal"},
        'easy'
    ,
    (gen_random_uuid(),
        'Какао с молоком',
        '[{"stepNo":1,"text":"Вскипятить молоко.","timerSec":180},{"stepNo":2,"text":"Добавить какао и подождать.","timerSec":60}]'::jsonb,
        5,
        {"pot"},
        1,
        {"breakfast", "snack", "comfort"},
        'easy'
    ,
    (gen_random_uuid(),
        'Торт «Саратов»',
        '[{"stepNo":1,"text":"Замесить бисквит.","timerSec":300},{"stepNo":2,"text":"Выпести коржи.","timerSec":2400},{"stepNo":3,"text":"Смазать кремом и оформить.","timerSec":1200}]'::jsonb,
        90,
        {"oven", "pan"},
        8,
        {"dessert", "comfort"},
        'hard'
    ,
    (gen_random_uuid(),
        'Птичфе «Медовый»',
        '[{"stepNo":1,"text":"Замесить тесто с медом и орехами.","timerSec":600},{"stepNo":2,"text":"Выпекать 25 минут.","timerSec":1500}]'::jsonb,
        60,
        {"oven", "pan"},
        6,
        {"dessert", "comfort"},
        'medium'
    ,
    (gen_random_uuid(),
        'Вафля тяжёлая',
        '[{"stepNo":1,"text":"Смешать тесто.","timerSec":120},{"stepNo":2,"text":"Испечать вафлю.","timerSec":600}]'::jsonb,
        10,
        {"wafel iron"},
        2,
        {"breakfast", "dessert"},
        'easy'
    ,
    (gen_random_uuid(),
        'Фланк-стейк',
        '[{"stepNo":1,"text":"Обжарить мясо с солью и перцем.","timerSec":600},{"stepNo":2,"text":"Обжарить в гриле.","timerSec":300}]'::jsonb,
        15,
        {"stove", "pan"},
        2,
        {"lunch", "dinner", "premium"},
        'medium'
    ,
    (gen_random_uuid(),
        'Шашлык из свинины',
        '[{"stepNo":1,"text":"Намариновать мясо в луке и соли.","timerSec":1800},{"stepNo":2,"text":"Зажечь огонь и жарить.","timerSec":900}]'::jsonb,
        30,
        {"grill", "bowl"},
        4,
        {"lunch", "dinner", "grill"},
        'medium'
    ,
    (gen_random_uuid(),
        'Рыба на гриле с зеленью',
        '[{"stepNo":1,"text":"Marinate fish with butter and herbs.","timerSec":300},{"stepNo":2,"text":"Grill for 8 minutes per side.","timerSec":960}]'::jsonb,
        20,
        {"grill", "pan"},
        2,
        {"lunch", "dinner", "fish"},
        'medium'
    ,
    (gen_random_uuid(),
        'Креветки с рисом',
        '[{"stepNo":1,"text":"Сварить рис.","timerSec":900},{"stepNo":2,"text":"Обжарить креветки с маслом.","timerSec":300},{"stepNo":3,"text":"Смешать и подать.","timerSec":0}]'::jsonb,
        25,
        {"stove", "pan", "pot"},
        2,
        {"lunch", "dinner", "seafood"},
        'easy'
    ,
    (gen_random_uuid(),
        'Запечённый картофель с бобами',
        '[{"stepNo":1,"text":"Сварить картофель.","timerSec":1200},{"stepNo":2,"text":"Запекать с горохом.","timerSec":1200}]'::jsonb,
        50,
        {"oven", "pan"},
        4,
        {"lunch", "dinner", "vegan"},
        'easy'
    ,
    (gen_random_uuid(),
        'Мясная нарезка',
        '[{"stepNo":1,"text":"Нарезать ветчину и сыр.","timerSec":0},{"stepNo":2,"text":"Подать на тарелке.","timerSec":0}]'::jsonb,
        5,
        {"plate", "knife"},
        2,
        {"lunch", "snack"},
        'easy'
    ,
    (gen_random_uuid(),
        'Творожная запеканка',
        '[{"stepNo":1,"text":"Смешать творог, муку, яйцо и изюм.","timerSec":300},{"stepNo":2,"text":"Выпекать 20 минут.","timerSec":1200}]'::jsonb,
        40,
        {"oven", "pan"},
        4,
        {"breakfast", "dessert", "protein"},
        'medium'
    ,
    (gen_random_uuid(),
        'Макароны по-флорентийски',
        '[{"stepNo":1,"text":"Сварить макароны.","timerSec":600},{"stepNo":2,"text":"Приготовить соус из чеснока и масла.","timerSec":300}]'::jsonb,
        30,
        {"pot", "stove"},
        2,
        {"lunch", "dinner"},
        'easy'
    ,
    (gen_random_uuid(),
        'Салат из моркови и черники',
        '[{"stepNo":1,"text":"Натереть морковь.","timerSec":0},{"stepNo":2,"text":"Смешать с черникой и масло.","timerSec":0}]'::jsonb,
        8,
        {"bowl", "knife"},
        2,
        {"lunch", "side", "fruit"},
        'easy'
    ,
    (gen_random_uuid(),
        'Овсянка с ягодами и горстью',
        '[{"stepNo":1,"text":"Сварить овсянку на молоке.","timerSec":180},{"stepNo":2,"text":"Добавить горсть семян и ягоды.","timerSec":0}]'::jsonb,
        8,
        {"pot", "blender"},
        1,
        {"breakfast", "protein"},
        'easy'
    ,
    (gen_random_uuid(),
        'Суп из гороха с зеленью',
        '[{"stepNo":1,"text":"Сварить горох.","timerSec":1200},{"stepNo":2,"text":"Протереть и подавать.","timerSec":0}]'::jsonb,
        30,
        {"pot", "stove"},
        4,
        {"lunch", "dinner", "vegan"},
        'easy'
    ,
    (gen_random_uuid(),
        'Гречка с сосиской',
        '[{"stepNo":1,"text":"Сварить гечку.","timerSec":900},{"stepNo":2,"text":"Обжарить сосиски.","timerSec":300}]'::jsonb,
        20,
        {"stove", "pan"},
        1,
        {"lunch", "dinner", "cheap"},
        'easy'
    ,
    (gen_random_uuid(),
        'Запечённый брокколи с сыром',
        '[{"stepNo":1,"text":"Нарезать брокколи.","timerSec":0},{"stepNo":2,"text":"Посыпать сыром и запечь.","timerSec":900}]'::jsonb,
        25,
        {"oven", "pan"},
        2,
        {"lunch", "side", "vegetable"},
        'easy'
    ,
    (gen_random_uuid(),
        'Суп из чечевицы с овощами',
        '[{"stepNo":1,"text":"Сварить чечевицу с овощами.","timerSec":1800},{"stepNo":2,"text":"Протереть.","timerSec":0}]'::jsonb,
        40,
        {"pot", "stove"},
        4,
        {"lunch", "dinner", "vegan", "fiber"},
        'easy'
    ,
    (gen_random_uuid(),
        'Филе утки с вишнёй',
        '[{"stepNo":1,"text":"Обжарить филе утки.","timerSec":600},{"stepNo":2,"text":"Приготовить соус из вишни.","timerSec":300}]'::jsonb,
        45,
        {"stove", "pan"},
        2,
        {"lunch", "dinner", "premium"},
        'hard'
    ,
    (gen_random_uuid(),
        'Картофельное пюре',
        '[{"stepNo":1,"text":"Сварить картофель.","timerSec":1200},{"stepNo":2,"text":"Растереть с маслом и молоком.","timerSec":0}]'::jsonb,
        25,
        {"pot", "stove"},
        4,
        {"side", "comfort"},
        'easy'
    ,
    (gen_random_uuid(),
        'Яичный суфле',
        '[{"stepNo":1,"text":"Взбить белки.","timerSec":120},{"stepNo":2,"text":"Запечь в духовке.","timerSec":900}]'::jsonb,
        30,
        {"oven", "bowl"},
        2,
        {"breakfast", "dessert"},
        'medium'
    ,
    (gen_random_uuid(),
        'Салат из огурцов',
        '[{"stepNo":1,"text":"Нарезать огурцы.","timerSec":0},{"stepNo":2,"text":"Смешать с маслом и солью.","timerSec":0}]'::jsonb,
        8,
        {"bowl", "knife"},
        2,
        {"lunch", "side", "lowcal"},
        'easy'
    ,
    (gen_random_uuid(),
        'Филе семги на сковороде',
        '[{"stepNo":1,"text":"Marinate fish with oil and herbs.","timerSec":300},{"stepNo":2,"text":"Обжарить 5 минут.","timerSec":300}]'::jsonb,
        15,
        {"stove", "pan"},
        2,
        {"lunch", "dinner", "fish"},
        'medium'
    ,
    (gen_random_uuid(),
        'Гречка с хлебом',
        '[{"stepNo":1,"text":"Сварить гечку.","timerSec":900},{"stepNo":2,"text":"Подать с хлебом.","timerSec":0}]'::jsonb,
        20,
        {"stove", "pan"},
        2,
        {"lunch", "dinner", "traditional"},
        'easy'
    ,
    (gen_random_uuid(),
        'Запека из овощей с яйцами',
        '[{"stepNo":1,"text":"Смешать овощи и яйца.","timerSec":300},{"stepNo":2,"text":"Запекать 25 минут.","timerSec":1500}]'::jsonb,
        35,
        {"oven", "pan"},
        4,
        {"lunch", "dinner", "vegetable"},
        'easy'
    ,
    (gen_random_uuid(),
        'Хумус с лавашом',
        '[{"stepNo":1,"text":"Смешать горох, чеснок и масло.","timerSec":300},{"stepNo":2,"text":"Подать с лавашом.","timerSec":0}]'::jsonb,
        15,
        {"blender", "plate"},
        2,
        {"lunch", "snack", "vegan"},
        'easy'
    ,
    (gen_random_uuid(),
        'Творожок с горстью',
        '[{"stepNo":1,"text":"Смешать творог и горсть.","timerSec":0},{"stepNo":2,"text":"Подать с морковным соком.","timerSec":0}]'::jsonb,
        5,
        {"bowl"},
        1,
        {"breakfast", "protein"},
        'easy'
    ,
    (gen_random_uuid(),
        'Салат из пекинской капусты',
        '[{"stepNo":1,"text":"Нашинковать капусту.","timerSec":0},{"stepNo":2,"text":"Смешать с уксусом и маслом.","timerSec":0}]'::jsonb,
        8,
        {"bowl", "knife"},
        2,
        {"lunch", "side", "lowcal"},
        'easy'
    ,
    (gen_random_uuid(),
        'Филе трески на сковороде',
        '[{"stepNo":1,"text":"Marinate fish with oil and herbs.","timerSec":300},{"stepNo":2,"text":"Обжарить 5 минут.","timerSec":300}]'::jsonb,
        15,
        {"stove", "pan"},
        2,
        {"lunch", "dinner", "fish"},
        'easy'
    ,
    (gen_random_uuid(),
        'Торт «Фундук»',
        '[{"stepNo":1,"text":"Замесить тесто с фундуком.","timerSec":600},{"stepNo":2,"text":"Выпекать 30 минут.","timerSec":1800}]'::jsonb,
        90,
        {"oven", "pan"},
        8,
        {"dessert", "comfort"},
        'hard'
    ,
    (gen_random_uuid(),
        'Картофель с горохом',
        '[{"stepNo":1,"text":"Сварить картофель.","timerSec":1200},{"stepNo":2,"text":"Смешать с горохом.","timerSec":0}]'::jsonb,
        25,
        {"stove", "pot"},
        2,
        {"lunch", "dinner", "vegan"},
        'easy'
    ,
    (gen_random_uuid(),
        'Яичница',
        '[{"stepNo":1,"text":"Разбить яйца.","timerSec":0},{"stepNo":2,"text":"Потушить под крышкой.","timerSec":180}]'::jsonb,
        6,
        {"stove", "pan"},
        1,
        {"breakfast", "lunch"},
        'easy')
;

-- Recipe-ingredient links (grams_raw per base serving)
INSERT INTO core.recipe_ingredients (recipe_id, ingredient_id, grams_raw, optional, substitution_group)
VALUES
    ((SELECT id FROM core.recipes WHERE title = 'Куриное филе на сковороде с отварной гречкой'), (SELECT id FROM core.ingredients WHERE name = 'Гречневая крупа ядрица'), 50::numeric, false, 'base_grain')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Куриное филе на сковороде с отварной гречкой'), (SELECT id FROM core.ingredients WHERE name = 'Филе курицы'), 150::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Куриное филе на сковороде с отварной гречкой'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 30::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Куриное филе на сковороде с отварной гречкой'), (SELECT id FROM core.ingredients WHERE name = 'Масло растительное'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Куриное филе на сковороде с отварной гречкой'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 2::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Овсянка на молоке с ягодами'), (SELECT id FROM core.ingredients WHERE name = 'Хлопья овсяные'), 40::numeric, false, 'base_grain')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Овсянка на молоке с ягодами'), (SELECT id FROM core.ingredients WHERE name = 'Молоко коровье 2,5%'), 150::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Овсянка на молоке с ягодами'), (SELECT id FROM core.ingredients WHERE name = 'Клубника'), 40::numeric, false, 'base_fruit')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Овсянка на молоке с ягодами'), (SELECT id FROM core.ingredients WHERE name = 'Мед'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожные сырники'), (SELECT id FROM core.ingredients WHERE name = 'Творог постный 0%'), 300::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожные сырники'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 2::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожные сырники'), (SELECT id FROM core.ingredients WHERE name = 'Пшеничная мука'), 20::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожные сырники'), (SELECT id FROM core.ingredients WHERE name = 'Мед'), 30::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Бутерброды с ветчиной и сыром'), (SELECT id FROM core.ingredients WHERE name = 'Хлеб пшеничный'), 50::numeric, false, 'base_carb')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Бутерброды с ветчиной и сыром'), (SELECT id FROM core.ingredients WHERE name = 'Ветчина'), 40::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Бутерброды с ветчиной и сыром'), (SELECT id FROM core.ingredients WHERE name = 'Сыр пармезан'), 20::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Бутерброды с ветчиной и сыром'), (SELECT id FROM core.ingredients WHERE name = 'Масло сливочное 72,5%'), 5::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Бирьяни с курицей'), (SELECT id FROM core.ingredients WHERE name = 'Рис длинный басмати'), 200::numeric, false, 'base_grain')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Бирьяни с курицей'), (SELECT id FROM core.ingredients WHERE name = 'Филе курицы'), 300::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Бирьяни с курицей'), (SELECT id FROM core.ingredients WHERE name = 'Масло рапсовое'), 15::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Бирьяни с курицей'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 3::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Бирьяни с курицей'), (SELECT id FROM core.ingredients WHERE name = 'Перец чёрный молотый'), 1::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп картофельный с кремом'), (SELECT id FROM core.ingredients WHERE name = 'Картофель'), 400::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп картофельный с кремом'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 80::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп картофельный с кремом'), (SELECT id FROM core.ingredients WHERE name = 'Лук репчатый'), 40::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп картофельный с кремом'), (SELECT id FROM core.ingredients WHERE name = 'Масло сливочное 72,5%'), 20::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп картофельный с кремом'), (SELECT id FROM core.ingredients WHERE name = 'Укроп'), 5::numeric, true, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с куриной грудкой и овощами'), (SELECT id FROM core.ingredients WHERE name = 'Гречневая крупа ядрица'), 60::numeric, false, 'base_grain')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с куриной грудкой и овощами'), (SELECT id FROM core.ingredients WHERE name = 'Куриная грудка'), 180::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с куриной грудкой и овощами'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 40::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с куриной грудкой и овощами'), (SELECT id FROM core.ingredients WHERE name = 'Огурцы'), 40::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с куриной грудкой и овощами'), (SELECT id FROM core.ingredients WHERE name = 'Масло растительное'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Яичница-глазунья'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 2::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Яичница-глазунья'), (SELECT id FROM core.ingredients WHERE name = 'Укроп'), 5::numeric, true, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Яичница-глазунья'), (SELECT id FROM core.ingredients WHERE name = 'Масло сливочное 72,5%'), 5::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Яичница-глазунья'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 1::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запеканка картофельная'), (SELECT id FROM core.ingredients WHERE name = 'Картофель'), 500::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запеканка картофельная'), (SELECT id FROM core.ingredients WHERE name = 'Молоко коровье 3,2%'), 150::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запеканка картофельная'), (SELECT id FROM core.ingredients WHERE name = 'Сыр пармезан'), 40::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запеканка картофельная'), (SELECT id FROM core.ingredients WHERE name = 'Масло сливочное 72,5%'), 30::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Рагу из свеклы и моркови'), (SELECT id FROM core.ingredients WHERE name = 'Свёкла'), 200::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Рагу из свеклы и моркови'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 150::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Рагу из свеклы и моркови'), (SELECT id FROM core.ingredients WHERE name = 'Лук репчатый'), 50::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Рагу из свеклы и моркови'), (SELECT id FROM core.ingredients WHERE name = 'Масло подсолнечное'), 15::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Рагу из свеклы и моркови'), (SELECT id FROM core.ingredients WHERE name = 'Томатная пассата'), 50::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Пельмени домашние'), (SELECT id FROM core.ingredients WHERE name = 'Пшеничная мука'), 200::numeric, false, 'base_carb')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Пельмени домашние'), (SELECT id FROM core.ingredients WHERE name = 'Филе свинины'), 200::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Пельмени домашние'), (SELECT id FROM core.ingredients WHERE name = 'Капуста белокочанная'), 100::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Пельмени домашние'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 1::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Пельмени домашние'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 3::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Омлет с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 4::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Омлет с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Молоко коровье 2,5%'), 60::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Омлет с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Перец болгарский'), 60::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Омлет с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Лук репчатый'), 30::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Омлет с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Масло растительное'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из огурцов и свеклы'), (SELECT id FROM core.ingredients WHERE name = 'Огурцы'), 150::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из огурцов и свеклы'), (SELECT id FROM core.ingredients WHERE name = 'Свёкла'), 100::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из огурцов и свеклы'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 50::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из огурцов и свеклы'), (SELECT id FROM core.ingredients WHERE name = 'Укроп'), 5::numeric, true, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из огурцов и свеклы'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 2::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Куриный суп-лапша'), (SELECT id FROM core.ingredients WHERE name = 'Филе курицы'), 300::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Куриный суп-лапша'), (SELECT id FROM core.ingredients WHERE name = 'Лапша тонкая'), 100::numeric, false, 'base_carb')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Куриный суп-лапша'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 60::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Куриный суп-лапша'), (SELECT id FROM core.ingredients WHERE name = 'Лук зелёный'), 10::numeric, true, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Куриный суп-лапша'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 3::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Чечевичный суп с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Чечевица красная'), 150::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Чечевичный суп с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Лук репчатый'), 50::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Чечевичный суп с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 60::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Чечевичный суп с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Томатная пассата'), 80::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Чечевичный суп с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Сметана 10%'), 30::numeric, true, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с индейкой'), (SELECT id FROM core.ingredients WHERE name = 'Гречневая крупа ядрица'), 60::numeric, false, 'base_grain')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с индейкой'), (SELECT id FROM core.ingredients WHERE name = 'Филе индейки'), 150::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с индейкой'), (SELECT id FROM core.ingredients WHERE name = 'Масло растительное'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с индейкой'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 2::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Картофель фри'), (SELECT id FROM core.ingredients WHERE name = 'Картофель'), 400::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Картофель фри'), (SELECT id FROM core.ingredients WHERE name = 'Масло растительное'), 20::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Картофель фри'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 3::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из цикория и гранатовой кислоты'), (SELECT id FROM core.ingredients WHERE name = 'Сельдерей'), 80::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из цикория и гранатовой кислоты'), (SELECT id FROM core.ingredients WHERE name = 'Яблоки антоновские'), 80::numeric, false, 'base_fruit')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из цикория и гранатовой кислоты'), (SELECT id FROM core.ingredients WHERE name = 'Масло оливковое'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из цикория и гранатовой кислоты'), (SELECT id FROM core.ingredients WHERE name = 'Уксус'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Какао с молоком'), (SELECT id FROM core.ingredients WHERE name = 'Молоко коровье 3,2%'), 200::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Какао с молоком'), (SELECT id FROM core.ingredients WHERE name = 'Сахар'), 15::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Какао с молоком'), (SELECT id FROM core.ingredients WHERE name = 'Какао-порошок'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Торт «Саратов»'), (SELECT id FROM core.ingredients WHERE name = 'Пшеничная мука'), 300::numeric, false, 'base_carb')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Торт «Саратов»'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 6::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Торт «Саратов»'), (SELECT id FROM core.ingredients WHERE name = 'Сахар'), 250::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Торт «Саратов»'), (SELECT id FROM core.ingredients WHERE name = 'Масло сливочное 72,5%'), 150::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Птичфе «Медовый»'), (SELECT id FROM core.ingredients WHERE name = 'Пшеничная мука'), 200::numeric, false, 'base_carb')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Птичфе «Медовый»'), (SELECT id FROM core.ingredients WHERE name = 'Грецкие орещи'), 100::numeric, false, 'base_fat')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Птичфе «Медовый»'), (SELECT id FROM core.ingredients WHERE name = 'Мед'), 80::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Птичфе «Медовый»'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 3::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Вафля тяжёлая'), (SELECT id FROM core.ingredients WHERE name = 'Пшеничная мука'), 150::numeric, false, 'base_carb')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Вафля тяжёлая'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 2::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Вафля тяжёлая'), (SELECT id FROM core.ingredients WHERE name = 'Молоко коровье 3,2%'), 100::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Вафля тяжёлая'), (SELECT id FROM core.ingredients WHERE name = 'Масло сливочное 72,5%'), 50::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Фланк-стейк'), (SELECT id FROM core.ingredients WHERE name = 'Говядина подоскасник'), 300::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Фланк-стейк'), (SELECT id FROM core.ingredients WHERE name = 'Масло подсолнечное'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Фланк-стейк'), (SELECT id FROM core.ingredients WHERE name = 'Перец чёрный молотый'), 2::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Шашлык из свинины'), (SELECT id FROM core.ingredients WHERE name = 'Свинина лопатка'), 500::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Шашлык из свинины'), (SELECT id FROM core.ingredients WHERE name = 'Лук репчатый'), 100::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Шашлык из свинины'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 5::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Рыба на гриле с зеленью'), (SELECT id FROM core.ingredients WHERE name = 'Филе лосося'), 200::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Рыба на гриле с зеленью'), (SELECT id FROM core.ingredients WHERE name = 'Масло сливочное 72,5%'), 20::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Рыба на гриле с зеленью'), (SELECT id FROM core.ingredients WHERE name = 'Петрушка'), 5::numeric, true, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Рыба на гриле с зеленью'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 2::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Креветки с рисом'), (SELECT id FROM core.ingredients WHERE name = 'Креветки мерклэн'), 200::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Креветки с рисом'), (SELECT id FROM core.ingredients WHERE name = 'Рис длинный басмати'), 100::numeric, false, 'base_grain')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Креветки с рисом'), (SELECT id FROM core.ingredients WHERE name = 'Масло рапсовое'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запечённый картофель с бобами'), (SELECT id FROM core.ingredients WHERE name = 'Картофель'), 500::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запечённый картофель с бобами'), (SELECT id FROM core.ingredients WHERE name = 'Горох морской'), 100::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запечённый картофель с бобами'), (SELECT id FROM core.ingredients WHERE name = 'Масло растительное'), 20::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Мясная нарезка'), (SELECT id FROM core.ingredients WHERE name = 'Ветчина'), 100::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Мясная нарезка'), (SELECT id FROM core.ingredients WHERE name = 'Сыр пармезан'), 50::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Мясная нарезка'), (SELECT id FROM core.ingredients WHERE name = 'Хлеб пшеничный'), 50::numeric, false, 'base_carb')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожная запеканка'), (SELECT id FROM core.ingredients WHERE name = 'Творог постный 0%'), 400::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожная запеканка'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 3::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожная запеканка'), (SELECT id FROM core.ingredients WHERE name = 'Пшеничная мука'), 40::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожная запеканка'), (SELECT id FROM core.ingredients WHERE name = 'Сахар'), 50::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Макароны по-флорентийски'), (SELECT id FROM core.ingredients WHERE name = 'Макароны'), 100::numeric, false, 'base_carb')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Макароны по-флорентийски'), (SELECT id FROM core.ingredients WHERE name = 'Чеснок'), 20::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Макароны по-флорентийски'), (SELECT id FROM core.ingredients WHERE name = 'Масло оливковое'), 20::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Макароны по-флорентийски'), (SELECT id FROM core.ingredients WHERE name = 'Перец чёрный молотый'), 1::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из моркови и черники'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 150::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из моркови и черники'), (SELECT id FROM core.ingredients WHERE name = 'Черника'), 50::numeric, false, 'base_fruit')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из моркови и черники'), (SELECT id FROM core.ingredients WHERE name = 'Масло оливковое'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Овсянка с ягодами и горстью'), (SELECT id FROM core.ingredients WHERE name = 'Хлопья овсяные'), 40::numeric, false, 'base_grain')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Овсянка с ягодами и горстью'), (SELECT id FROM core.ingredients WHERE name = 'Молоко коровье 3,2%'), 150::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Овсянка с ягодами и горстью'), (SELECT id FROM core.ingredients WHERE name = 'Горсть семян льна'), 20::numeric, false, 'base_fat')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Овсянка с ягодами и горстью'), (SELECT id FROM core.ingredients WHERE name = 'Клубника'), 40::numeric, false, 'base_fruit')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп из гороха с зеленью'), (SELECT id FROM core.ingredients WHERE name = 'Горох морской'), 150::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп из гороха с зеленью'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 80::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп из гороха с зеленью'), (SELECT id FROM core.ingredients WHERE name = 'Укроп'), 5::numeric, true, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп из гороха с зеленью'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 3::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с сосиской'), (SELECT id FROM core.ingredients WHERE name = 'Гечневая крупа ядрица'), 50::numeric, false, 'base_grain')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с сосиской'), (SELECT id FROM core.ingredients WHERE name = 'Сосиски куриные'), 100::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с сосиской'), (SELECT id FROM core.ingredients WHERE name = 'Масло растительное'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запечённый брокколи с сыром'), (SELECT id FROM core.ingredients WHERE name = 'Капуста броколистная'), 300::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запечённый брокколи с сыром'), (SELECT id FROM core.ingredients WHERE name = 'Сыр пармезан'), 30::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запечённый брокколи с сыром'), (SELECT id FROM core.ingredients WHERE name = 'Масло оливковое'), 15::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп из чечевицы с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Чечевица зелёная'), 150::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп из чечевицы с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Лук репчатый'), 60::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп из чечевицы с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 80::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Суп из чечевицы с овощами'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 3::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Филе утки с вишнёй'), (SELECT id FROM core.ingredients WHERE name = 'Филе утки'), 200::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Филе утки с вишнёй'), (SELECT id FROM core.ingredients WHERE name = 'Вишня'), 100::numeric, false, 'base_fruit')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Филе утки с вишнёй'), (SELECT id FROM core.ingredients WHERE name = 'Масло сливочное 72,5%'), 20::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Картофельное пюре'), (SELECT id FROM core.ingredients WHERE name = 'Картофель'), 500::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Картофельное пюре'), (SELECT id FROM core.ingredients WHERE name = 'Молоко коровье 2,5%'), 100::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Картофельное пюре'), (SELECT id FROM core.ingredients WHERE name = 'Масло сливочное 72,5%'), 30::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Картофельное пюре'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 3::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Яичный суфле'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 4::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Яичный суфле'), (SELECT id FROM core.ingredients WHERE name = 'Молоко коровье 2,5%'), 50::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Яичный суфле'), (SELECT id FROM core.ingredients WHERE name = 'Сахар'), 20::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из огурцов'), (SELECT id FROM core.ingredients WHERE name = 'Огурцы'), 200::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из огурцов'), (SELECT id FROM core.ingredients WHERE name = 'Укроп'), 5::numeric, true, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из огурцов'), (SELECT id FROM core.ingredients WHERE name = 'Масло подсолнечное'), 15::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Филе семги на сковороде'), (SELECT id FROM core.ingredients WHERE name = 'Филе семги'), 200::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Филе семги на сковороде'), (SELECT id FROM core.ingredients WHERE name = 'Масло оливковое'), 15::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Филе семги на сковороде'), (SELECT id FROM core.ingredients WHERE name = 'Петрушка'), 5::numeric, true, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с хлебом'), (SELECT id FROM core.ingredients WHERE name = 'Гечневая крупа ядрица'), 60::numeric, false, 'base_grain')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с хлебом'), (SELECT id FROM core.ingredients WHERE name = 'Хлеб пшеничный'), 50::numeric, false, 'base_carb')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Гречка с хлебом'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 2::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запека из овощей с яйцами'), (SELECT id FROM core.ingredients WHERE name = 'Капуста белокочанная'), 200::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запека из овощей с яйцами'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 4::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запека из овощей с яйцами'), (SELECT id FROM core.ingredients WHERE name = 'Морковь'), 100::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Запека из овощей с яйцами'), (SELECT id FROM core.ingredients WHERE name = 'Сметана 10%'), 50::numeric, false, 'base_dairy')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Хумус с лавашом'), (SELECT id FROM core.ingredients WHERE name = 'Горох морской'), 200::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Хумус с лавашом'), (SELECT id FROM core.ingredients WHERE name = 'Чеснок'), 15::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Хумус с лавашом'), (SELECT id FROM core.ingredients WHERE name = 'Масло оливковое'), 30::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Хумус с лавашом'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 3::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожок с горстью'), (SELECT id FROM core.ingredients WHERE name = 'Творог постный 0%'), 150::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожок с горстью'), (SELECT id FROM core.ingredients WHERE name = 'Горсть семян подсолнуха'), 20::numeric, false, 'base_fat')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Творожок с горстью'), (SELECT id FROM core.ingredients WHERE name = 'Морковный сок'), 100::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из пекинской капусты'), (SELECT id FROM core.ingredients WHERE name = 'Капуста пекинская'), 200::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из пекинской капусты'), (SELECT id FROM core.ingredients WHERE name = 'Уксус'), 10::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Салат из пекинской капусты'), (SELECT id FROM core.ingredients WHERE name = 'Масло подсолнечное'), 15::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Филе трески на сковороде'), (SELECT id FROM core.ingredients WHERE name = 'Филе трески'), 200::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Филе трески на сковороде'), (SELECT id FROM core.ingredients WHERE name = 'Масло растительное'), 15::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Филе трески на сковороде'), (SELECT id FROM core.ingredients WHERE name = 'Соль'), 2::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Торт «Фундук»'), (SELECT id FROM core.ingredients WHERE name = 'Пшеничная мука'), 250::numeric, false, 'base_carb')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Торт «Фундук»'), (SELECT id FROM core.ingredients WHERE name = 'Грецкие орещи'), 150::numeric, false, 'base_fat')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Торт «Фундук»'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 5::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Торт «Фундук»'), (SELECT id FROM core.ingredients WHERE name = 'Сахар'), 200::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Картофель с горохом'), (SELECT id FROM core.ingredients WHERE name = 'Картофель'), 300::numeric, false, 'base_veg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Картофель с горохом'), (SELECT id FROM core.ingredients WHERE name = 'Горох морской'), 100::numeric, false, 'base_protein')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Картофель с горохом'), (SELECT id FROM core.ingredients WHERE name = 'Масло растительное'), 15::numeric, false, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Яичница'), (SELECT id FROM core.ingredients WHERE name = 'Яйца куриные'), 2::numeric, false, 'base_egg')
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Яичница'), (SELECT id FROM core.ingredients WHERE name = 'Укроп'), 5::numeric, true, NULL)
    ,
    ((SELECT id FROM core.recipes WHERE title = 'Яичница'), (SELECT id FROM core.ingredients WHERE name = 'Масло сливочное 72,5%'), 5::numeric, false, NULL)
;
