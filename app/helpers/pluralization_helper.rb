module PluralizationHelper
  def russian_pluralize(number, one, few, many)
    return many if (11..14).include?(number % 100)
    case number % 10
    when 1
      one
    when 2..4
      few
    else
      many
    end
  end
end
