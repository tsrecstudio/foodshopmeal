-- =====================================================================
-- V003__seed_ingredients_rf_300.sql
-- Stage M1: 300 base RF ingredients.
-- Sources: Skurikhin / FGU tables (representative values).
-- Nutrients are per 100 g of edible raw portion.
-- =====================================================================

INSERT INTO core.ingredients
    (id, name, synonyms, category, kcal_per_100g, protein_per_100g, fat_per_100g,
     carb_per_100g, fiber_per_100g, density_g_per_ml, yield_factor_cooked,
     waste_factor, allergens, tags)
VALUES
    (gen_random_uuid(), 'Крупа овсяная', ARRAY['крупа', 'крупа овсяная'], 'grains', 329, 9.5, 5.3, 62.0, 10.0, 0.62, 2.60, 0.12, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Хлопья овсяные', ARRAY['хлопья овсяные'], 'grains', 377, 12.6, 8.0, 62.0, 10.0, 0.45, 1.00, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Овсянка быстрого приготовления', ARRAY['овсянка быстрого приготовления'], 'grains', 370, 12.0, 7.0, 63.0, 9.0, 0.45, 1.00, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Гречневая крупа ядрица', ARRAY['гречневая крупа ядрица'], 'grains', 352, 12.4, 2.4, 67.0, 14.0, 0.85, 2.80, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Гречневая крупа просеянная', ARRAY['гречневая крупа просеянная'], 'grains', 350, 12.6, 2.5, 66.0, 14.4, 0.85, 2.80, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Гречневая крупа твёрдая', ARRAY['гречневая крупа твёрдая'], 'grains', 348, 13.0, 2.2, 65.0, 15.0, 0.85, 2.70, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Рис круглый', ARRAY['рис круглый'], 'grains', 332, 5.9, 0.5, 72.0, 1.3, 0.85, 2.60, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Рис длинный басмати', ARRAY['рис длинный басмати'], 'grains', 343, 5.2, 0.8, 76.0, 1.4, 0.85, 2.40, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Рис зерновой', ARRAY['рис зерновой'], 'grains', 328, 6.1, 0.5, 73.0, 1.2, 0.85, 2.50, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа просяная', ARRAY['крупа просяная'], 'grains', 347, 12.5, 3.0, 64.0, 5.0, 0.75, 2.90, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа кукурузная манная', ARRAY['крупа кукурузная манная', 'крупа манная'], 'grains', 320, 7.2, 2.0, 70.0, 4.0, 0.70, 2.90, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа пшеничная манная', ARRAY['крупа манная', 'крупа пшеничная манная'], 'grains', 333, 11.7, 1.5, 72.0, 4.0, 0.70, 3.10, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа кукурузная крупная', ARRAY['крупа крупная', 'крупа кукурузная крупная'], 'grains', 319, 8.0, 3.5, 66.0, 6.0, 0.70, 2.90, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Спагетти', ARRAY['спагетти'], 'grains', 349, 12.0, 1.0, 70.0, 3.0, 0.78, 2.30, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Макароны', ARRAY['макароны'], 'grains', 340, 11.0, 1.5, 68.0, 3.5, 0.78, 2.30, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Лапша тонкая', ARRAY['лапша тонкая'], 'grains', 338, 11.5, 2.0, 68.0, 3.0, 0.78, 2.30, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Лапша удлинённая', ARRAY['лапша удлинённая'], 'grains', 345, 11.8, 1.8, 69.0, 3.0, 0.78, 2.30, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Киноа', ARRAY['киноа'], 'grains', 368, 14.1, 6.1, 64.0, 7.0, 0.80, 2.50, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Булгур', ARRAY['булгур'], 'grains', 340, 9.0, 2.0, 72.0, 4.0, 0.80, 2.40, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа ячменная', ARRAY['крупа ячменная'], 'grains', 354, 9.9, 1.9, 72.0, 4.0, 0.80, 3.10, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа ячменная цельный', ARRAY['крупа ячменная цельный'], 'grains', 350, 10.0, 2.0, 72.0, 4.5, 0.80, 3.00, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа овсяная постная', ARRAY['крупа овсяная постная', 'крупа постная'], 'grains', 340, 12.0, 5.0, 64.0, 8.0, 0.62, 2.60, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа пшеничная тонкодисперсная', ARRAY['крупа пшеничная тонкодисперсная', 'крупа тонкодисперсная'], 'grains', 345, 10.0, 1.0, 74.0, 3.0, 0.70, 2.60, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа пшеничная крупнодисперсная', ARRAY['крупа крупнодисперсная', 'крупа пшеничная крупнодисперсная'], 'grains', 340, 11.0, 0.8, 73.0, 3.5, 0.70, 2.60, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа гречневая интегральная', ARRAY['крупа гречневая интегральная'], 'grains', 352, 12.6, 2.5, 66.0, 14.0, 0.85, 2.80, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Хлопья ячменные', ARRAY['хлопья ячменные'], 'grains', 342, 9.0, 2.0, 68.0, 6.0, 0.55, 1.00, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Хлопья пшеничные', ARRAY['хлопья пшеничные'], 'grains', 355, 10.0, 3.0, 70.0, 6.0, 0.55, 1.00, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Хлопья кукурузные', ARRAY['хлопья кукурузные'], 'grains', 340, 8.0, 4.0, 70.0, 7.0, 0.55, 1.00, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа рисовая протомченная', ARRAY['крупа протомченная', 'крупа рисовая протомченная'], 'grains', 350, 6.0, 0.6, 77.0, 1.0, 0.85, 2.60, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Крупа рисовая шлифованная', ARRAY['крупа рисовая шлифованная', 'крупа шлифованная'], 'grains', 332, 5.9, 0.5, 72.0, 1.3, 0.85, 2.60, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Горох морской', ARRAY['горох морской'], 'legumes', 150, 10.0, 0.6, 26.0, 6.0, 0.85, 1.00, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Горох сухой цельный', ARRAY['горох сухой цельный'], 'legumes', 342, 21.0, 1.5, 55.0, 15.0, 0.80, 2.10, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Чечевица красная', ARRAY['чечевица красная'], 'legumes', 340, 23.0, 1.5, 56.0, 14.0, 0.80, 2.40, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Чечевица зелёная', ARRAY['чечевица зелёная'], 'legumes', 345, 24.0, 2.0, 55.0, 12.0, 0.80, 2.30, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Фасоль сухая', ARRAY['фасоль сухая'], 'legumes', 330, 22.0, 1.5, 56.0, 12.0, 0.80, 2.30, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Нут сухой', ARRAY['нут сухой'], 'legumes', 358, 19.0, 6.0, 63.0, 10.0, 0.80, 2.20, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Гороховая крупа', ARRAY['гороховая', 'гороховая крупа'], 'legumes', 320, 18.0, 1.5, 57.0, 13.0, 0.80, 2.00, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Чевильная крупа', ARRAY['чевильная', 'чевильная крупа'], 'legumes', 335, 20.0, 1.8, 58.0, 14.0, 0.80, 2.20, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Фасоль стручковая', ARRAY['фасоль стручковая'], 'legumes', 27, 1.7, 0.3, 5.4, 1.4, 0.92, 1.00, 0.12, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Горошек зелёный', ARRAY['горошек зелёный'], 'legumes', 81, 5.4, 0.4, 14.4, 5.7, 0.90, 1.00, 0.10, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Горошек стручковый', ARRAY['горошек стручковый'], 'legumes', 42, 3.5, 0.2, 7.7, 3.0, 0.90, 1.00, 0.10, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Горошек консервированный', ARRAY['горошек консервированный'], 'legumes', 75, 4.5, 0.3, 12.0, 5.0, 0.85, 1.00, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Чечевица вымоканная', ARRAY['чечевица вымоканная'], 'legumes', 105, 8.0, 0.5, 19.0, 4.0, 0.80, 2.40, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Горох вымоканный', ARRAY['горох вымоканный'], 'legumes', 120, 8.5, 0.5, 20.0, 4.0, 0.80, 2.10, 0.0, '{}'::text[], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Тофу', ARRAY['тофу'], 'legumes', 76, 8.0, 4.8, 2.0, 0.4, 1.00, 1.00, 0.0, ARRAY['soy'], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Соевые орещи', ARRAY['соевые орещи'], 'legumes', 395, 35.0, 19.0, 30.0, 4.0, 0.85, 1.00, 0.0, ARRAY['soy'], ARRAY['legumes', 'plant_protein'])
    ,
    (gen_random_uuid(), 'Молоко коровье 2,5%', ARRAY['молоко коровье 2,5%'], 'dairy', 58, 3.2, 2.5, 4.7, 0.0, 1.03, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Молоко коровье 3,2%', ARRAY['молоко коровье 3,2%'], 'dairy', 64, 3.2, 3.2, 4.7, 0.0, 1.03, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Молоко коровье 3,5%', ARRAY['молоко коровье 3,5%'], 'dairy', 67, 3.2, 3.5, 4.7, 0.0, 1.03, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Молоко обезжиренное 0,5%', ARRAY['молоко обезжиренное 0,5%'], 'dairy', 42, 3.2, 0.5, 4.9, 0.0, 1.03, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Молоко козье', ARRAY['молоко козье'], 'dairy', 62, 3.4, 3.5, 4.6, 0.0, 1.03, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Молоко миндальное', ARRAY['молоко миндальное'], 'dairy', 30, 1.0, 2.5, 2.0, 0.5, 1.03, 1.00, 0.0, '{}'::text[], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Молоко соевое', ARRAY['молоко соевое'], 'dairy', 33, 3.0, 1.5, 1.7, 0.2, 1.03, 1.00, 0.0, ARRAY['soy'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Молоко кокосовое', ARRAY['молоко кокосовое'], 'dairy', 170, 2.0, 17.0, 7.0, 3.0, 1.00, 1.00, 0.0, '{}'::text[], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Кефир 3,2%', ARRAY['кефир 3,2%'], 'dairy', 60, 3.0, 3.0, 4.8, 0.0, 1.03, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Кефир 2,5%', ARRAY['кефир 2,5%'], 'dairy', 54, 2.9, 2.5, 4.9, 0.0, 1.03, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Кефир 1,5%', ARRAY['кефир 1,5%'], 'dairy', 44, 2.8, 1.5, 5.0, 0.0, 1.03, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Ряженка', ARRAY['ряженка'], 'dairy', 70, 3.0, 4.0, 5.0, 0.0, 1.03, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Простокваша', ARRAY['простокваша'], 'dairy', 55, 2.8, 2.5, 4.9, 0.0, 1.03, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Творог постный 0%', ARRAY['творог постный 0%'], 'dairy', 74, 17.0, 0.0, 3.5, 0.0, 1.00, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Творог пресный 2%', ARRAY['творог пресный 2%'], 'dairy', 88, 16.0, 2.0, 3.5, 0.0, 1.00, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Творог жирный 5%', ARRAY['творог жирный 5%'], 'dairy', 105, 15.0, 5.0, 3.4, 0.0, 1.00, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Творог жирный 9%', ARRAY['творог жирный 9%'], 'dairy', 140, 13.0, 9.0, 3.0, 0.0, 1.00, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сметана 10%', ARRAY['сметана 10%'], 'dairy', 90, 2.5, 10.0, 4.0, 0.0, 1.01, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сметана 15%', ARRAY['сметана 15%'], 'dairy', 125, 2.3, 15.0, 3.8, 0.0, 1.01, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сметана 20%', ARRAY['сметана 20%'], 'dairy', 160, 2.0, 20.0, 3.6, 0.0, 1.01, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Масло сливочное 72,5%', ARRAY['масло сливочное 72,5%'], 'dairy', 737, 0.8, 80.0, 0.5, 0.0, 0.93, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Масло сливочное 78,5%', ARRAY['масло сливочное 78,5%'], 'dairy', 750, 0.7, 82.0, 0.5, 0.0, 0.93, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Масло топленое', ARRAY['масло топленое'], 'dairy', 750, 1.0, 82.0, 0.0, 0.0, 0.92, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сыр творожный', ARRAY['сыр творожный'], 'dairy', 110, 13.0, 6.0, 4.0, 0.0, 1.00, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сыр пармезан', ARRAY['сыр пармезан'], 'dairy', 390, 30.0, 28.0, 2.0, 0.0, 1.05, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сыр чеддер', ARRAY['сыр чеддер'], 'dairy', 395, 25.0, 31.0, 1.0, 0.0, 1.05, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сыр голубой', ARRAY['сыр голубой'], 'dairy', 350, 22.0, 28.0, 2.0, 0.0, 1.05, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сыр моцарella', ARRAY['сыр моцарella'], 'dairy', 280, 22.0, 22.0, 1.0, 0.0, 1.00, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сыр рикотта', ARRAY['сыр рикотта'], 'dairy', 180, 14.0, 14.0, 2.0, 0.0, 1.00, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сыр гриль', ARRAY['сыр гриль'], 'dairy', 330, 22.0, 26.0, 1.0, 0.0, 1.05, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Сыр колбасный', ARRAY['сыр колбасный'], 'dairy', 330, 22.0, 26.0, 1.0, 0.0, 1.05, 1.00, 0.0, ARRAY['milk'], ARRAY['calcium', 'dairy'])
    ,
    (gen_random_uuid(), 'Масло растительное', ARRAY['масло растительное'], 'fats', 884, 0.0, 99.9, 0.0, 0.0, 0.92, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Масло подсолнечное', ARRAY['масло подсолнечное'], 'fats', 884, 0.0, 99.9, 0.0, 0.0, 0.92, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Масло рапсовое', ARRAY['масло рапсовое'], 'fats', 890, 0.1, 99.8, 0.0, 0.0, 0.92, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Масло оливковое', ARRAY['масло оливковое'], 'fats', 884, 0.0, 99.9, 0.0, 0.0, 0.91, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Масло соевое', ARRAY['масло соевое'], 'fats', 880, 0.0, 99.9, 0.0, 0.0, 0.92, 1.00, 0.0, ARRAY['soy'], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Масло льняное', ARRAY['масло льняное'], 'fats', 895, 0.1, 99.8, 0.0, 0.0, 0.92, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Масло кукурузное', ARRAY['масло кукурузное'], 'fats', 884, 0.0, 99.9, 0.0, 0.0, 0.92, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Масло кокосовое', ARRAY['масло кокосовое'], 'fats', 900, 0.0, 99.0, 0.0, 0.0, 0.90, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Margarine', ARRAY['margarine'], 'fats', 650, 0.5, 65.0, 2.0, 0.0, 0.92, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Margarine спрей', ARRAY['margarine спрей'], 'fats', 650, 0.5, 65.0, 2.0, 0.0, 0.92, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Margarine пальмовое', ARRAY['margarine пальмовое'], 'fats', 650, 0.5, 65.0, 2.0, 0.0, 0.92, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Margarine безжировое', ARRAY['margarine безжировое'], 'fats', 300, 0.0, 20.0, 2.0, 0.0, 0.92, 1.00, 0.0, '{}'::text[], ARRAY['fats'])
    ,
    (gen_random_uuid(), 'Яйца куриные', ARRAY['яйца куриные'], 'eggs', 156, 12.6, 10.3, 1.0, 0.0, 1.03, 1.00, 0.0, ARRAY['eggs'], ARRAY['eggs'])
    ,
    (gen_random_uuid(), 'Яйца перепёлочные', ARRAY['яйца перепёлочные'], 'eggs', 170, 13.5, 11.0, 1.0, 0.0, 1.03, 1.00, 0.0, ARRAY['eggs'], ARRAY['eggs'])
    ,
    (gen_random_uuid(), 'Яичный белок', ARRAY['яичный белок'], 'eggs', 48, 11.0, 0.1, 0.8, 0.0, 1.03, 1.00, 0.0, ARRAY['eggs'], ARRAY['eggs'])
    ,
    (gen_random_uuid(), 'Яичный желток', ARRAY['яичный желток'], 'eggs', 360, 15.0, 30.0, 1.0, 0.0, 1.03, 1.00, 0.0, ARRAY['eggs'], ARRAY['eggs'])
    ,
    (gen_random_uuid(), 'Яйца куриные варёные', ARRAY['яйца куриные варёные'], 'eggs', 155, 12.5, 10.0, 1.0, 0.0, 1.03, 1.00, 0.0, ARRAY['eggs'], ARRAY['eggs'])
    ,
    (gen_random_uuid(), 'Яйца перепёлочные варёные', ARRAY['яйца перепёлочные варёные'], 'eggs', 160, 13.0, 10.0, 1.0, 0.0, 1.03, 1.00, 0.0, ARRAY['eggs'], ARRAY['eggs'])
    ,
    (gen_random_uuid(), 'Яичные пасты', ARRAY['яичные пасты'], 'eggs', 110, 10.0, 8.0, 1.0, 0.0, 1.03, 1.00, 0.0, ARRAY['eggs', 'milk'], ARRAY['eggs'])
    ,
    (gen_random_uuid(), 'Икра куриная', ARRAY['икра куриная'], 'eggs', 120, 13.0, 8.0, 2.0, 0.0, 1.03, 1.00, 0.0, ARRAY['eggs'], ARRAY['eggs'])
    ,
    (gen_random_uuid(), 'Филе курицы', ARRAY['филе курицы'], 'meat', 133, 22.9, 4.4, 0.0, 0.0, 1.00, 0.75, 0.03, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Куриная грудка', ARRAY['куриная грудка'], 'meat', 120, 22.6, 4.6, 0.0, 0.0, 1.00, 0.74, 0.04, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Куриные окорочка', ARRAY['куриные окорочка'], 'meat', 172, 18.2, 10.0, 0.0, 0.0, 1.00, 0.70, 0.10, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Куриные бедры', ARRAY['куриные бедры'], 'meat', 181, 17.0, 11.0, 0.0, 0.0, 1.00, 0.70, 0.12, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Куриные голено-бедровые', ARRAY['куриные голено-бедровые'], 'meat', 168, 17.5, 10.0, 0.0, 0.0, 1.00, 0.70, 0.14, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Филе индейки', ARRAY['филе индейки'], 'meat', 130, 22.8, 4.0, 0.0, 0.0, 1.00, 0.75, 0.03, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Грудка индейки', ARRAY['грудка индейки'], 'meat', 127, 23.0, 3.6, 0.0, 0.0, 1.00, 0.74, 0.04, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Филе утки', ARRAY['филе утки'], 'meat', 196, 22.0, 12.0, 0.0, 0.0, 1.00, 0.72, 0.08, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Говядина подоскасник', ARRAY['говядина подоскасник'], 'meat', 190, 20.0, 12.0, 0.0, 0.0, 1.00, 0.70, 0.12, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Говядина свияга', ARRAY['говядина свияга'], 'meat', 183, 21.0, 10.0, 0.0, 0.0, 1.00, 0.71, 0.10, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Говядина тазобедренная', ARRAY['говядина тазобедренная'], 'meat', 189, 19.5, 12.5, 0.0, 0.0, 1.00, 0.70, 0.13, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Свинина подоскасник', ARRAY['свинина подоскасник'], 'meat', 170, 19.0, 12.0, 0.0, 0.0, 1.00, 0.72, 0.10, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Свинина лопатка', ARRAY['свинина лопатка'], 'meat', 175, 17.0, 13.0, 0.0, 0.0, 1.00, 0.72, 0.11, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Свинина колено', ARRAY['свинина колено'], 'meat', 190, 16.0, 15.0, 0.0, 0.0, 1.00, 0.71, 0.12, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Филе свинины', ARRAY['филе свинины'], 'meat', 152, 19.0, 9.0, 0.0, 0.0, 1.00, 0.73, 0.08, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Телячина', ARRAY['телячина'], 'meat', 155, 20.0, 8.0, 0.0, 0.0, 1.00, 0.74, 0.06, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Сосиски куриные', ARRAY['сосиски куриные'], 'meat', 220, 14.0, 18.0, 3.0, 0.0, 1.00, 0.80, 0.05, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Сардельки куриные', ARRAY['сардельки куриные'], 'meat', 230, 13.0, 19.0, 3.5, 0.0, 1.00, 0.80, 0.05, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Печень куриная', ARRAY['печень куриная'], 'meat', 127, 17.0, 5.0, 1.0, 0.0, 1.00, 0.80, 0.05, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Печень говяжья', ARRAY['печень говяжья'], 'meat', 117, 20.0, 4.0, 1.0, 0.0, 1.00, 0.80, 0.06, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Сердце куриное', ARRAY['сердце куриное'], 'meat', 102, 17.0, 6.0, 1.0, 0.0, 1.00, 0.80, 0.10, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Горечи куриные', ARRAY['горечи куриные'], 'meat', 130, 14.0, 10.0, 0.0, 0.0, 1.00, 0.75, 0.15, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Ветчина', ARRAY['ветчина'], 'meat', 190, 16.0, 15.0, 2.0, 0.0, 1.00, 0.90, 0.08, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Кролик', ARRAY['кролик'], 'meat', 175, 20.0, 9.0, 0.0, 0.0, 1.00, 0.75, 0.15, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Оленина', ARRAY['оленина'], 'meat', 145, 22.0, 5.0, 0.0, 0.0, 1.00, 0.75, 0.10, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Говядина', ARRAY['говядина'], 'meat', 190, 20.0, 12.0, 0.0, 0.0, 1.00, 0.70, 0.12, '{}'::text[], ARRAY['meat', 'protein'])
    ,
    (gen_random_uuid(), 'Филе трески', ARRAY['рыба', 'филе трески'], 'fish', 82, 18.0, 0.8, 0.0, 0.0, 1.00, 0.85, 0.03, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе горбуши', ARRAY['рыба', 'филе горбуши'], 'fish', 110, 19.0, 2.0, 0.0, 0.0, 1.00, 0.80, 0.03, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе иваси', ARRAY['рыба', 'филе иваси'], 'fish', 100, 19.0, 2.0, 0.0, 0.0, 1.00, 0.82, 0.03, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе пикши', ARRAY['рыба', 'филе пикши'], 'fish', 90, 18.0, 1.5, 0.0, 0.0, 1.00, 0.83, 0.03, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе лосося', ARRAY['рыба', 'филе лосося'], 'fish', 170, 22.0, 9.0, 0.0, 0.0, 1.00, 0.80, 0.05, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе семги', ARRAY['рыба', 'филе семги'], 'fish', 210, 20.0, 15.0, 0.0, 0.0, 1.00, 0.80, 0.05, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе кумжи', ARRAY['рыба', 'филе кумжи'], 'fish', 100, 19.0, 2.0, 0.0, 0.0, 1.00, 0.82, 0.03, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе тальмана', ARRAY['рыба', 'филе тальмана'], 'fish', 95, 18.0, 2.0, 0.0, 0.0, 1.00, 0.82, 0.03, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Сельдь', ARRAY['рыба', 'сельдь'], 'fish', 215, 21.0, 16.0, 0.0, 0.0, 1.00, 0.95, 0.02, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Сельдь средней жирности', ARRAY['рыба', 'сельдь средней жирности'], 'fish', 190, 18.0, 14.0, 0.0, 0.0, 1.00, 0.95, 0.02, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Сельдь малосольная', ARRAY['рыба', 'сельдь малосольная'], 'fish', 180, 17.0, 13.0, 0.0, 0.0, 1.00, 0.95, 0.02, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Шпроты в масле', ARRAY['рыба', 'шпроты в масле'], 'fish', 260, 18.0, 20.0, 0.0, 0.0, 0.90, 1.00, 0.0, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Килька', ARRAY['килька', 'рыба'], 'fish', 120, 15.0, 7.0, 0.0, 0.0, 1.00, 0.90, 0.02, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Креветки мерклэн', ARRAY['креветки мерклэн'], 'seafood', 100, 21.0, 1.5, 0.0, 0.0, 1.00, 0.70, 0.20, ARRAY['seafood'], ARRAY['seafood'])
    ,
    (gen_random_uuid(), 'Креветки нерки', ARRAY['креветки нерки'], 'seafood', 106, 20.0, 2.0, 0.0, 0.0, 1.00, 0.70, 0.20, ARRAY['seafood'], ARRAY['seafood'])
    ,
    (gen_random_uuid(), 'Мидия', ARRAY['мидия'], 'seafood', 90, 14.0, 2.0, 3.0, 0.0, 0.90, 0.50, 0.20, '{}'::text[], ARRAY['seafood'])
    ,
    (gen_random_uuid(), 'Гребень', ARRAY['гребень'], 'seafood', 60, 12.0, 1.0, 1.0, 0.0, 0.90, 0.60, 0.30, '{}'::text[], ARRAY['seafood'])
    ,
    (gen_random_uuid(), 'Крабы', ARRAY['крабы'], 'seafood', 80, 15.0, 1.0, 2.0, 0.0, 0.90, 0.55, 0.25, '{}'::text[], ARRAY['seafood'])
    ,
    (gen_random_uuid(), 'Икра лососевая', ARRAY['икра лососевая', 'рыба'], 'fish', 250, 18.0, 20.0, 0.0, 0.0, 0.95, 1.00, 0.0, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе камбалы', ARRAY['рыба', 'филе камбалы'], 'fish', 110, 18.0, 3.0, 0.0, 0.0, 1.00, 0.75, 0.05, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе копченого лосося', ARRAY['рыба', 'филе копченого лосося'], 'fish', 180, 20.0, 10.0, 0.0, 0.0, 1.00, 0.80, 0.05, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе копченого семги', ARRAY['рыба', 'филе копченого семги'], 'fish', 220, 18.0, 16.0, 0.0, 0.0, 1.00, 0.80, 0.05, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе карпа', ARRAY['рыба', 'филе карпа'], 'fish', 115, 18.0, 5.0, 0.0, 0.0, 1.00, 0.75, 0.08, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Филе снетка', ARRAY['рыба', 'филе снетка'], 'fish', 90, 18.0, 1.5, 0.0, 0.0, 1.00, 0.82, 0.03, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Рыба горбуша', ARRAY['рыба', 'рыба горбуша'], 'fish', 110, 19.0, 2.0, 0.0, 0.0, 1.00, 0.80, 0.03, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Угорь', ARRAY['рыба', 'угорь'], 'fish', 120, 17.0, 8.0, 0.0, 0.0, 1.00, 0.75, 0.05, ARRAY['fish'], ARRAY['fish', 'omega3'])
    ,
    (gen_random_uuid(), 'Картофель', ARRAY['картофель', 'овощ'], 'vegetables', 77, 2.0, 0.1, 17.0, 1.8, 0.80, 0.85, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Морковь', ARRAY['морковь', 'овощ'], 'vegetables', 32, 1.0, 0.1, 6.7, 2.8, 0.86, 0.85, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Свёкла', ARRAY['овощ', 'свёкла'], 'vegetables', 42, 1.5, 0.1, 9.6, 2.0, 0.88, 0.90, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Лук репчатый', ARRAY['лук репчатый', 'овощ'], 'vegetables', 37, 1.1, 0.1, 8.9, 1.7, 0.90, 0.90, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Лук зелёный', ARRAY['лук зелёный', 'овощ'], 'vegetables', 32, 1.4, 0.3, 7.0, 1.8, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Чеснок', ARRAY['овощ', 'чеснок'], 'vegetables', 149, 6.4, 0.5, 33.0, 2.1, 0.95, 1.00, 0.05, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Помидоры', ARRAY['овощ', 'помидоры'], 'vegetables', 18, 0.9, 0.2, 3.8, 1.2, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Огурцы', ARRAY['овощ', 'огурцы'], 'vegetables', 15, 0.7, 0.1, 3.6, 0.8, 0.96, 1.00, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Капуста белокочанная', ARRAY['капуста белокочанная', 'овощ'], 'vegetables', 27, 1.8, 0.1, 6.0, 1.7, 0.90, 1.00, 0.12, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Капуста красная', ARRAY['капуста красная', 'овощ'], 'vegetables', 31, 1.4, 0.2, 6.9, 1.9, 0.90, 1.00, 0.12, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Капуста пекинская', ARRAY['капуста пекинская', 'овощ'], 'vegetables', 14, 0.9, 0.2, 3.3, 1.0, 0.90, 1.00, 0.12, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Капуста цветная', ARRAY['капуста цветная', 'овощ'], 'vegetables', 34, 2.6, 0.3, 5.0, 2.5, 0.90, 0.80, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Капуста броколистная', ARRAY['капуста броколистная', 'овощ'], 'vegetables', 30, 2.5, 0.5, 6.0, 3.0, 0.90, 0.90, 0.12, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Перец болгарский', ARRAY['овощ', 'перец болгарский'], 'vegetables', 26, 1.0, 0.2, 5.7, 2.3, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Перец болгарский красный', ARRAY['овощ', 'перец болгарский красный'], 'vegetables', 31, 1.1, 0.2, 7.1, 2.5, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Перец болгарский желтый', ARRAY['овощ', 'перец болгарский желтый'], 'vegetables', 31, 1.1, 0.2, 7.1, 2.5, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Перец болгарский зелёный', ARRAY['овощ', 'перец болгарский зелёный'], 'vegetables', 20, 1.0, 0.1, 4.8, 2.1, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Баклажан', ARRAY['баклажан', 'овощ'], 'vegetables', 24, 1.2, 0.1, 5.9, 3.5, 0.90, 1.00, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Цукини', ARRAY['овощ', 'цукини'], 'vegetables', 18, 1.2, 0.1, 4.4, 1.1, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Кабачок', ARRAY['кабачок', 'овощ'], 'vegetables', 18, 1.2, 0.1, 4.4, 1.1, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Тыква', ARRAY['овощ', 'тыква'], 'vegetables', 26, 1.0, 0.1, 6.5, 0.8, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Редис', ARRAY['овощ', 'редис'], 'vegetables', 16, 0.6, 0.1, 3.6, 1.0, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Редька', ARRAY['овощ', 'редька'], 'vegetables', 18, 0.9, 0.1, 4.1, 1.6, 0.95, 1.00, 0.12, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Турнепис', ARRAY['овощ', 'турнепис'], 'vegetables', 20, 1.0, 0.1, 4.0, 1.5, 0.95, 1.00, 0.12, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Топинамур', ARRAY['овощ', 'топинамур'], 'vegetables', 57, 2.0, 0.1, 12.0, 3.0, 0.90, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Шпинат', ARRAY['овощ', 'шпинат'], 'vegetables', 23, 2.9, 0.4, 3.6, 2.2, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Щавель', ARRAY['овощ', 'щавель'], 'vegetables', 22, 1.8, 0.3, 4.2, 1.5, 0.90, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Латук', ARRAY['латук', 'овощ'], 'vegetables', 15, 1.4, 0.2, 2.9, 1.3, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Кресс', ARRAY['кресс', 'овощ'], 'vegetables', 22, 2.6, 0.3, 3.7, 2.2, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Подорожник', ARRAY['овощ', 'подорожник'], 'vegetables', 33, 3.0, 0.7, 4.1, 3.4, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Крапива', ARRAY['крапива', 'овощ'], 'vegetables', 43, 5.0, 0.7, 7.4, 5.6, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Подснежник', ARRAY['овощ', 'подснежник'], 'vegetables', 33, 2.9, 0.4, 6.2, 3.8, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Укроп', ARRAY['овощ', 'укроп'], 'vegetables', 41, 2.7, 0.5, 8.7, 3.2, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Петрушка', ARRAY['овощ', 'петрушка'], 'vegetables', 36, 3.0, 0.6, 6.9, 3.7, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Кинза', ARRAY['кинза', 'овощ'], 'vegetables', 36, 2.1, 0.7, 6.9, 2.8, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Базилик', ARRAY['базилик', 'овощ'], 'vegetables', 23, 1.2, 0.6, 2.7, 1.6, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Сельдерей', ARRAY['овощ', 'сельдерей'], 'vegetables', 18, 0.9, 0.2, 3.5, 1.6, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fiber', 'vegetables'])
    ,
    (gen_random_uuid(), 'Яблоки', ARRAY['фрукт', 'яблоки'], 'fruits', 52, 0.4, 0.2, 13.0, 2.4, 0.85, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Яблоки антоновские', ARRAY['фрукт', 'яблоки антоновские'], 'fruits', 50, 0.4, 0.2, 12.5, 2.2, 0.85, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Яблоки гренни смит', ARRAY['фрукт', 'яблоки гренни смит'], 'fruits', 52, 0.4, 0.2, 13.0, 2.4, 0.85, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Груши', ARRAY['груши', 'фрукт'], 'fruits', 57, 0.4, 0.1, 14.3, 3.1, 0.86, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Груши сибирские', ARRAY['груши сибирские', 'фрукт'], 'fruits', 55, 0.4, 0.1, 13.0, 3.0, 0.86, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Сливы', ARRAY['сливы', 'фрукт'], 'fruits', 40, 0.7, 0.2, 9.9, 1.5, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Чернослив', ARRAY['фрукт', 'чернослив'], 'fruits', 162, 1.9, 0.3, 35.0, 7.1, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Абрикосы', ARRAY['абрикосы', 'фрукт'], 'fruits', 44, 0.9, 0.2, 10.5, 2.0, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Персики', ARRAY['персики', 'фрукт'], 'fruits', 43, 0.9, 0.1, 10.0, 1.7, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Апельсин', ARRAY['апельсин', 'фрукт'], 'fruits', 43, 0.9, 0.2, 10.0, 2.4, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Грейпфрут', ARRAY['грейпфрут', 'фрукт'], 'fruits', 38, 0.7, 0.1, 8.5, 1.6, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Ананас', ARRAY['ананас', 'фрукт'], 'fruits', 48, 0.5, 0.2, 11.0, 1.4, 0.90, 1.00, 0.15, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Банан', ARRAY['банан', 'фрукт'], 'fruits', 90, 1.5, 0.2, 22.0, 1.2, 0.90, 1.00, 0.20, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Вишня', ARRAY['вишня', 'фрукт'], 'fruits', 48, 1.0, 0.3, 11.0, 1.6, 0.95, 1.00, 0.15, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Клубника', ARRAY['клубника', 'фрукт'], 'fruits', 32, 0.8, 0.4, 7.7, 2.0, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Клубника садовая', ARRAY['клубника садовая', 'фрукт'], 'fruits', 32, 0.8, 0.4, 7.7, 2.0, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Малина', ARRAY['малина', 'фрукт'], 'fruits', 38, 1.2, 0.5, 7.7, 6.2, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Клюква', ARRAY['клюква', 'фрукт'], 'fruits', 25, 0.4, 0.1, 5.4, 2.3, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Черника', ARRAY['фрукт', 'черника'], 'fruits', 35, 0.7, 0.3, 7.9, 4.2, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Смородина красная', ARRAY['смородина красная', 'фрукт'], 'fruits', 48, 1.4, 0.2, 11.0, 4.3, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Смородина чёрная', ARRAY['смородина чёрная', 'фрукт'], 'fruits', 65, 1.5, 0.4, 14.7, 6.0, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['fruit', 'fruits'])
    ,
    (gen_random_uuid(), 'Арахис', ARRAY['арахис'], 'nuts', 567, 25.8, 46.2, 16.1, 8.0, 0.60, 1.00, 0.05, ARRAY['nuts'], ARRAY['fat', 'nuts'])
    ,
    (gen_random_uuid(), 'Грецкие орехи', ARRAY['грецкие орехи'], 'nuts', 654, 15.0, 65.2, 13.7, 6.7, 0.60, 1.00, 0.05, ARRAY['nuts'], ARRAY['fat', 'nuts'])
    ,
    (gen_random_uuid(), 'Кедровые орещи', ARRAY['кедровые орещи'], 'nuts', 691, 12.5, 68.4, 13.3, 3.4, 0.60, 1.00, 0.05, ARRAY['nuts'], ARRAY['fat', 'nuts'])
    ,
    (gen_random_uuid(), 'Лещинные орещи', ARRAY['лещинные орещи'], 'nuts', 690, 14.0, 67.0, 14.0, 4.0, 0.60, 1.00, 0.05, ARRAY['nuts'], ARRAY['fat', 'nuts'])
    ,
    (gen_random_uuid(), 'Каштан', ARRAY['каштан'], 'nuts', 72, 1.3, 0.6, 16.0, 5.9, 0.80, 1.00, 0.10, ARRAY['nuts'], ARRAY['fat', 'nuts'])
    ,
    (gen_random_uuid(), 'Фисташки', ARRAY['фисташки'], 'nuts', 562, 20.2, 45.0, 17.7, 10.0, 0.65, 1.00, 0.05, ARRAY['nuts'], ARRAY['fat', 'nuts'])
    ,
    (gen_random_uuid(), 'Горсть', ARRAY['горсть'], 'nuts', 590, 18.0, 55.0, 18.0, 6.0, 0.60, 1.00, 0.05, ARRAY['nuts'], ARRAY['fat', 'nuts'])
    ,
    (gen_random_uuid(), 'Семена подсолнуха', ARRAY['семена подсолнуха'], 'nuts', 619, 20.2, 51.5, 15.7, 8.6, 0.60, 1.00, 0.10, '{}'::text[], ARRAY['fat', 'nuts'])
    ,
    (gen_random_uuid(), 'Семена конопли', ARRAY['семена конопли'], 'nuts', 553, 31.6, 48.75, 8.7, 4.0, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['fat', 'nuts'])
    ,
    (gen_random_uuid(), 'Горсть семян подсолнуха', ARRAY['горсть семян подсолнуха'], 'nuts', 619, 20.2, 51.5, 15.7, 8.6, 0.60, 1.00, 0.10, ARRAY['nuts'], ARRAY['fat', 'nuts'])
    ,
    (gen_random_uuid(), 'Соль', ARRAY['соль'], 'seasonings', 0, 0.0, 0.0, 0.0, 0.0, 1.00, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Ваниль', ARRAY['ваниль'], 'seasonings', 380, 0.1, 0.1, 50.0, 2.0, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Горчица', ARRAY['горчица'], 'seasonings', 114, 7.0, 6.0, 8.0, 1.8, 0.90, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Сахар', ARRAY['сахар'], 'seasonings', 399, 0.0, 0.0, 99.9, 0.0, 1.00, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Сахар тростниковый', ARRAY['сахар тростниковый'], 'seasonings', 400, 0.0, 0.0, 99.9, 0.0, 1.00, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Мед', ARRAY['мед'], 'seasonings', 329, 0.3, 0.0, 82.0, 2.0, 1.40, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Имбирь', ARRAY['имбирь'], 'seasonings', 68, 1.8, 0.5, 15.7, 2.0, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Куркума', ARRAY['куркума'], 'seasonings', 354, 6.6, 3.0, 64.9, 10.0, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Паприка', ARRAY['паприка'], 'seasonings', 228, 11.0, 6.8, 50.9, 27.2, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Паприка острая', ARRAY['паприка острая'], 'seasonings', 228, 11.0, 6.8, 50.9, 27.2, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Сладкая паприка', ARRAY['сладкая паприка'], 'seasonings', 228, 11.0, 6.8, 50.9, 27.2, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Орегано', ARRAY['орегано'], 'seasonings', 231, 9.0, 2.7, 52.0, 26.0, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Розмарин', ARRAY['розмарин'], 'seasonings', 129, 2.0, 2.0, 20.0, 24.0, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Тимьян', ARRAY['тимьян'], 'seasonings', 125, 1.5, 4.2, 27.5, 12.0, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Мелисса', ARRAY['мелисса'], 'seasonings', 70, 1.5, 0.5, 15.0, 4.0, 0.95, 1.00, 0.10, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Анис', ARRAY['анис'], 'seasonings', 357, 12.0, 2.0, 63.0, 20.0, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Тмин', ARRAY['тмин'], 'seasonings', 354, 15.0, 4.0, 58.0, 12.0, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Кунжут', ARRAY['кунжут'], 'seasonings', 574, 18.0, 50.0, 18.0, 14.0, 0.60, 1.00, 0.0, ARRAY['sesame'], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Кокос', ARRAY['кокос'], 'seasonings', 280, 2.0, 18.0, 6.0, 3.0, 0.80, 1.00, 0.10, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Соевый соус', ARRAY['соевый соус'], 'seasonings', 55, 8.0, 0.5, 7.0, 0.0, 1.15, 1.00, 0.0, ARRAY['soy'], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Кетчуп', ARRAY['кетчуп'], 'seasonings', 130, 1.0, 0.5, 30.0, 1.0, 1.05, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Майонез', ARRAY['майонез'], 'seasonings', 450, 1.0, 45.0, 3.0, 0.0, 0.90, 1.00, 0.0, ARRAY['eggs'], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Уксус', ARRAY['уксус'], 'seasonings', 15, 0.0, 0.0, 3.0, 0.0, 1.00, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Томатная пассата', ARRAY['томатная пассата'], 'seasonings', 26, 0.8, 0.2, 5.4, 1.2, 1.05, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Томкатный сок', ARRAY['томкатный сок'], 'seasonings', 20, 0.8, 0.1, 4.6, 0.8, 1.03, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Морковный сок', ARRAY['морковный сок'], 'seasonings', 40, 1.0, 0.2, 9.0, 1.4, 1.03, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Свёкольный сок', ARRAY['свёкольный сок'], 'seasonings', 40, 1.2, 0.2, 9.4, 1.5, 1.03, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Апельсиновый сок', ARRAY['апельсиновый сок'], 'seasonings', 44, 0.8, 0.2, 10.4, 0.2, 1.05, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Чеснок сухой', ARRAY['чеснок сухой'], 'seasonings', 225, 5.0, 1.0, 55.0, 2.0, 0.60, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Лук сухой', ARRAY['лук сухой'], 'seasonings', 300, 7.0, 0.5, 60.0, 8.0, 0.45, 1.00, 0.0, '{}'::text[], ARRAY['seasoning', 'seasonings'])
    ,
    (gen_random_uuid(), 'Пшеничная мука', ARRAY['пшеничная мука'], 'grains', 363, 10.3, 1.8, 73.0, 2.1, 0.55, 1.00, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Ржаная мука', ARRAY['ржаная мука'], 'grains', 325, 9.0, 1.5, 73.0, 12.0, 0.55, 1.00, 0.0, ARRAY['gluten'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Овсяная мука', ARRAY['овсяная мука'], 'grains', 389, 11.0, 6.5, 67.0, 10.0, 0.50, 1.00, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Гречневая мука', ARRAY['гречневая мука'], 'grains', 340, 13.0, 2.4, 68.0, 8.0, 0.65, 1.00, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Соевая мука', ARRAY['соевая мука'], 'grains', 378, 35.0, 19.0, 30.0, 4.0, 0.55, 1.00, 0.0, ARRAY['soy'], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Кокосовая мука', ARRAY['кокосовая мука'], 'grains', 660, 6.0, 24.0, 20.0, 10.0, 0.45, 1.00, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Гороховая мука', ARRAY['гороховая мука'], 'grains', 350, 22.0, 1.0, 56.0, 10.0, 0.55, 1.00, 0.0, '{}'::text[], ARRAY['carb', 'grains'])
    ,
    (gen_random_uuid(), 'Торт', ARRAY['торт'], 'bakery', 400, 5.0, 20.0, 48.0, 1.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Торт «Саратов»', ARRAY['торт «саратов»'], 'bakery', 400, 5.0, 20.0, 48.0, 1.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Торт «Вафля»', ARRAY['торт «вафля»'], 'bakery', 450, 6.0, 22.0, 48.0, 1.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Торт «Миндаль»', ARRAY['торт «миндаль»'], 'bakery', 450, 6.0, 22.0, 48.0, 1.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Торт «Фундук»', ARRAY['торт «фундук»'], 'bakery', 450, 6.0, 22.0, 48.0, 1.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs', 'nuts'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Птицфе', ARRAY['птицфе'], 'bakery', 450, 6.0, 22.0, 48.0, 1.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Печенье', ARRAY['печенье'], 'bakery', 450, 8.0, 25.0, 48.0, 2.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Печенье с кусочками', ARRAY['печенье с кусочками'], 'bakery', 450, 8.0, 25.0, 48.0, 2.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Печенье «Киндер»', ARRAY['печенье «киндер»'], 'bakery', 450, 8.0, 25.0, 48.0, 2.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Печенье «Батончик»', ARRAY['печенье «батончик»'], 'bakery', 450, 8.0, 25.0, 48.0, 2.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Печенье «Птицфе»', ARRAY['печенье «птицфе»'], 'bakery', 450, 8.0, 25.0, 48.0, 2.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Печенье «Тет-а-тет»', ARRAY['печенье «тет-а-тет»'], 'bakery', 450, 8.0, 25.0, 48.0, 2.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Печенье «Крамб»', ARRAY['печенье «крамб»'], 'bakery', 450, 8.0, 25.0, 48.0, 2.0, 0.40, 1.00, 0.0, ARRAY['gluten', 'milk', 'eggs'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Peanut butter', ARRAY['peanut butter'], 'bakery', 595, 25.0, 50.0, 20.0, 6.0, 0.70, 1.00, 0.0, ARRAY['nuts'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Peanut butter без сахара', ARRAY['peanut butter без сахара'], 'bakery', 595, 25.0, 50.0, 20.0, 6.0, 0.70, 1.00, 0.0, ARRAY['nuts'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Peanut butter с кусочками', ARRAY['peanut butter с кусочками'], 'bakery', 595, 25.0, 50.0, 20.0, 6.0, 0.70, 1.00, 0.0, ARRAY['nuts'], ARRAY['bakery'])
    ,
    (gen_random_uuid(), 'Marmalade', ARRAY['marmalade'], 'sweets', 280, 0.3, 0.1, 70.0, 0.0, 1.30, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Marmalade с апельсином', ARRAY['marmalade с апельсином'], 'sweets', 280, 0.3, 0.1, 70.0, 0.0, 1.30, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Marmalade с лимоном', ARRAY['marmalade с лимоном'], 'sweets', 280, 0.3, 0.1, 70.0, 0.0, 1.30, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel', ARRAY['caramel'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel молочный', ARRAY['caramel молочный'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel тёмный', ARRAY['caramel тёмный'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel белый', ARRAY['caramel белый'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с ванилью', ARRAY['caramel с ванилью'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с карамелью', ARRAY['caramel с карамелью'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с корицей', ARRAY['caramel с корицей'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с апельсином', ARRAY['caramel с апельсином'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с лимоном', ARRAY['caramel с лимоном'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с черникой', ARRAY['caramel с черникой'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с клубникой', ARRAY['caramel с клубникой'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с малиной', ARRAY['caramel с малиной'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с вишнёй', ARRAY['caramel с вишнёй'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с смородиной', ARRAY['caramel с смородиной'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с гранатом', ARRAY['caramel с гранатом'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с инжиром', ARRAY['caramel с инжиром'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с персиком', ARRAY['caramel с персиком'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с абрикосом', ARRAY['caramel с абрикосом'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с грушей', ARRAY['caramel с грушей'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с сливой', ARRAY['caramel с сливой'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с вишнёй и ягодой', ARRAY['caramel с вишнёй и ягодой'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с ягодой и фисташкой', ARRAY['caramel с ягодой и фисташкой'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с ягодой и миндалём', ARRAY['caramel с ягодой и миндалём'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с ягодой и кокосом', ARRAY['caramel с ягодой и кокосом'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с ягодой и грецким орехом', ARRAY['caramel с ягодой и грецким орехом'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с ягодой и арахисом', ARRAY['caramel с ягодой и арахисом'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
    ,
    (gen_random_uuid(), 'Caramel с ягодой и кедровым', ARRAY['caramel с ягодой и кедровым'], 'sweets', 350, 0.5, 0.5, 88.0, 0.0, 1.20, 1.00, 0.0, '{}'::text[], ARRAY['sweets'])
;
