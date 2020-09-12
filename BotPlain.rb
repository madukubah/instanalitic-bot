require 'watir' # Crawler

browser = Watir::Browser.new :chrome
browser.goto 'https://www.instagram.com/accounts/login/?hl=id'

browser.text_field(:name => "username").set "muhammadalfalahmadukubah"
browser.text_field(:name => "password").set "alanalin"
browser.button(:class => ["sqdOP", "L3NKy", "y3zKF"] ).click

begin
    browser.button(:class => ["sqdOP", "L3NKy", "y3zKF"] ).click
rescue
end


sleep(5)
if browser.button(:class => ['HoLwm'] ).exists?
    browser.button(:class => ['HoLwm'] ).click
end
sleep(3)

#mengumpulkan element yang mengandung tag tombol like
elements = browser.divs(:class => "eo2As ")
elements.each do |element|
    if element.button(:class => ['wpO6b '] ).svg(:class => "_8-yf5 ", :fill=>"#262626" ).exists?
        # tekan tombol like
        element.button(:class => ['wpO6b '] ).svg(:class => "_8-yf5 ", :fill=>"#262626" ).click
        sleep(3)
    end
end

sleep(500) # selesai