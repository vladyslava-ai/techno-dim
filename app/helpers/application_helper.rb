module ApplicationHelper                                 # [ЗГЕНЕРОВАНО] rails new
  # ---- власний код ----
  PIE_COLORS = %w[#6366f1 #ec4899 #10b981 #0ea5e9 #f59e0b #ef4444].freeze
  STATUS_CLASSES = {
    "Оформлено" => "s-new", "Підтверджено" => "s-ok", "Передано в доставку" => "s-ship",
    "Доставлено" => "s-done", "Скасовано" => "s-cancel"
  }.freeze

  def money(value)
    number_to_currency(value, unit: "₴", format: "%n %u", precision: 0, delimiter: " ")
  end

  # поточна ціна + перекреслена стара ціна та відсоток знижки (якщо є)
  def price_block(product)
    html = content_tag(:span, money(product.price), class: "now")
    if product.discount_percent
      html += content_tag(:s, money(product.old_price), class: "old")
      html += content_tag(:span, "-#{product.discount_percent}%", class: "off")
    end
    html
  end

  def stars(rating)
    "★" * rating.round + "☆" * (5 - rating.round)
  end

  # Зображення товару з public/products/<файл>; якщо файлу немає — текстова заглушка
  def product_image(product)
    if product.image.present?
      image_tag "/products/#{product.image}", alt: product.name
    else
      content_tag(:span, "Немає фото", class: "noimg")
    end
  end

  def status_badge(status)
    content_tag(:span, status, class: "status #{STATUS_CLASSES[status]}")
  end

  # CSS conic-gradient для кругової діаграми: {"Категорія" => кількість}
  def pie_gradient(data)
    total = data.values.sum
    return "conic-gradient(#e5e7eb 0 100%)" if total.zero?
    start = 0.0
    parts = data.each_with_index.map do |(_, n), i|
      stop = start + n * 100.0 / total
      part = "#{PIE_COLORS[i % PIE_COLORS.size]} #{start.round(2)}% #{stop.round(2)}%"
      start = stop
      part
    end
    "conic-gradient(#{parts.join(', ')})"
  end

  # SVG-іконка категорії (за ключовим словом у назві); без емодзі
  CATEGORY_ICONS = {
    /холод/i => '<rect x="18" y="6" width="28" height="52" rx="5"/><line x1="18" y1="26" x2="46" y2="26"/><line x1="24" y1="14" x2="24" y2="20"/><line x1="24" y1="32" x2="24" y2="42"/>',
    /прал/i  => '<rect x="10" y="6" width="44" height="52" rx="6"/><line x1="10" y1="18" x2="54" y2="18"/><circle cx="32" cy="38" r="13"/><circle cx="32" cy="38" r="6"/><circle cx="18" cy="12" r="1.5"/><circle cx="25" cy="12" r="1.5"/>',
    /пилос/i => '<rect x="8" y="34" width="32" height="16" rx="8"/><circle cx="17" cy="54" r="3"/><circle cx="33" cy="54" r="3"/><path d="M40 40h8a8 8 0 0 0 8-8V12"/><line x1="50" y1="12" x2="62" y2="12"/>'
  }.freeze
  DEFAULT_ICON = '<path d="M20 8h24l-4 30H24z"/><rect x="22" y="38" width="20" height="8" rx="3"/><rect x="16" y="46" width="32" height="10" rx="4"/>'.freeze

  def category_icon(name)
    inner = CATEGORY_ICONS.find { |re, _| name =~ re }&.last || DEFAULT_ICON
    raw(%(<svg viewBox="0 0 64 64" width="44" height="44" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">#{inner}</svg>))
  end

  def heart_icon
    raw('<svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" stroke-linejoin="round" aria-hidden="true"><path d="M12 21s-7.5-4.6-9.6-9.2C1 8.6 2.9 5 6.3 5c2.1 0 3.6 1.2 4.4 2.5h2.6C14.1 6.2 15.6 5 17.7 5c3.4 0 5.3 3.6 3.9 6.8C19.5 16.4 12 21 12 21z"/></svg>')
  end
end
