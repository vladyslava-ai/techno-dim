# власний код: тестові дані (rails db:seed)
OrderItem.destroy_all; Order.destroy_all; Review.destroy_all; Product.destroy_all; Category.destroy_all; User.destroy_all; Supplier.destroy_all

fridges = Category.create!(name: "Холодильники")
washers = Category.create!(name: "Пральні машини")
vacuums = Category.create!(name: "Пилососи")
small   = Category.create!(name: "Дрібна кухонна техніка")

data = [
  [fridges, "Холодильник Samsung RB34",   "Samsung", 21999, 5, "Двокамерний холодильник No Frost.", "Об'єм: 344 л\nЕнергоефективність: A++\nКолір: сталевий"],
  [fridges, "Холодильник LG GA-B459",     "LG",      19499, 3, "Холодильник з інверторним компресором.", "Об'єм: 384 л\nЕнергоефективність: A+\nКолір: білий"],
  [washers, "Пральна машина Bosch WAN",   "Bosch",   16999, 4, "Фронтальне завантаження, 8 кг.", "Завантаження: 8 кг\nВідпрацювання: 1200 об/хв\nЕнергоефективність: A+++"],
  [washers, "Пральна машина Samsung WW",  "Samsung", 14999, 6, "З функцією Eco Bubble.", "Завантаження: 7 кг\nВідпрацювання: 1000 об/хв\nЕнергоефективність: A++"],
  [vacuums, "Пилосос Dyson V8",           "Dyson",   13499, 2, "Бездротовий пилосос.", "Потужність: 115 Вт\nАвтономність: 40 хв\nВага: 2.6 кг"],
  [vacuums, "Пилосос Philips PowerPro",   "Philips",  5999, 8, "Пилосос з мішком, потужний.", "Потужність: 2000 Вт\nОб'єм контейнера: 1.5 л\nВага: 4.5 кг"],
  [small,   "Мультиварка Redmond RMC",    "Redmond",  2499, 10, "20 програм приготування.", "Потужність: 860 Вт\nОб'єм: 5 л"],
  [small,   "Блендер Bosch MSM",          "Bosch",    1799, 12, "Занурювальний блендер.", "Потужність: 600 Вт\nШвидкості: 2"],
  [small,   "Кавоварка Philips Series",   "Philips",  7999, 0, "Автоматична кавоварка (немає в наявності).", "Тиск: 15 бар"]
]
images = %w[fridge_samsung.jpg fridge_lg.jpg washer_bosch.jpg washer_samsung.jpg vacuum_dyson.jpg vacuum_philips.jpg multicooker_redmond.jpg blender_bosch.jpg coffee_philips.svg]
products = data.each_with_index.map do |(cat, name, brand, price, stock, desc, specs), i|
  Product.create!(category: cat, name: name, brand: brand, price: price, stock: stock,
                  description: desc, specs: specs, image: images[i])
end

products[0].reviews.create!(author: "Олена", rating: 5, body: "Тихий і місткий, рекомендую!")
products[0].reviews.create!(author: "Ігор",  rating: 4, body: "Гарний холодильник за свої гроші.")
products[2].reviews.create!(author: "Марія", rating: 5, body: "Пере чудово, мало шумить.")
products[5].reviews.create!(author: "Андрій", rating: 3, body: "Потужний, але гучний.")
Supplier.create!([
  { name: "Samsung Ukraine", contact: "+380 44 000 00 01, sales@samsung.example" },
  { name: "Bosch Побутова техніка", contact: "+380 44 000 00 02, order@bosch.example" },
  { name: "Philips Дистрибуція", contact: "+380 44 000 00 03, b2b@philips.example" }
])

# облікові записи для демонстрації (RBAC)
User.create!(name: "Адміністратор", email: "admin@techno-dim.example", password: "admin12345", role: "admin")
User.create!(name: "Покупець",      email: "buyer@techno-dim.example", password: "buyer12345", role: "customer")

puts "Створено: #{Category.count} категорій, #{Product.count} товарів, #{Review.count} відгуків, #{User.count} користувачів"

# власний код: стара ціна (акційні товари; потребує стовпця old_price)
{ "Холодильник Samsung RB34" => 24999, "Пральна машина Bosch WAN" => 18999,
  "Пилосос Dyson V8" => 15999, "Блендер Bosch MSM" => 2199 }.each do |name, old|
  Product.find_by(name: name)&.update!(old_price: old)
end
