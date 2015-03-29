xml.instruct!
xml.resume do
  xml.header do
    xml.full_name @resume.data.full_name
    xml.address1 @resume.data.address1
    xml.address2 @resume.data.address2
    xml.telephone @resume.data.telephone
    xml.email @resume.data.email
    xml.website @resume.data.url
  end

  @resume.data.sections.each do |section|
    xml.section title: section.title do
      xml.paragraph section.para if section.has_para?
      if section.has_items?
        xml.items do
          section.items.each do |item|
            xml.item item.text
          end
        end
      end

      if section.has_periods?
        section.periods.each do |period|
          xml.period title: period.title do
            xml.organization period.organization if period.has_organization?
            xml.location period.location if period.has_location?
            xml.date_start period.dtstart if period.has_dtstart?
            xml.date_end period.dtend if period.has_dtend?
            if period.has_items?
              xml.items do
                period.items.each do |item|
                  xml.item item.text
                end
              end
            end
          end
        end
      end
    end
  end
end