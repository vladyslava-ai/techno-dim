# Техно-Дім — оновлена версія

## Що оновлено
- Повністю оновлений темний преміальний дизайн (графіт + теплий бурштин), адаптивні картки, головна, каталог, форми, адміністративні сторінки.
- Підключено Bootstrap 5.3.3 CSS через CDN; локальні стилі працюють без інтернету, але Bootstrap потребує мережі.
- Виправлено `Europe/Kyiv` і прибрано маршрути до неіснуючого Admin::FavoritesController.
- Оформлення замовлення виконується в транзакції з блокуванням товарів, перевіркою залишків і відкатом при помилці.
- Додано фонове завдання `OrderConfirmationJob` для асинхронного запису події замовлення у Rails log. **Листи покупцям не надсилаються**.
- Додано тести моделей і інтеграційного сценарію покупки.
- Підготовлено Ruby 3.2.3 для вашого WSL.

## Запуск у WSL
1. Розпакуйте архів у нову папку (не перезаписуйте стару, поки не перевірите нову).
2. `cd ~/projects/techno_dim_premium/shop`
3. `bundle config set --local path vendor/bundle`
4. `bundle install`
5. `bundle exec rails server -p 3001`
6. Відкрийте http://localhost:3001

## Тести
`RAILS_ENV=test bundle exec rails db:test:prepare`
`RAILS_ENV=test bundle exec rails test test/models/product_validation_test.rb test/models/user_validation_test.rb test/integration/storefront_flow_test.rb`

Не використовуйте `rails db:reset` для основної бази: архів містить дані.

## Обмеження
Автоматичні тести не були запущені в середовищі створення архіву, оскільки тут немає встановлених залежностей Rails. Перевірте їх у WSL. Bootstrap завантажується з CDN. Для повноцінного відправлення email потрібні налаштування Action Mailer і SMTP-провайдер.
