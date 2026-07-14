#Home Page
user_registraion_link = "css:a[href^='register.htm']"
left_menu = ["Solutions","About Us","Services","Products","Locations","Admin Page"]
left_menu_list = "css:ul.leftmenu li:nth-child"
left_menu_list_css = "css:ul.leftmenu li"



#User Registration Page
registration_page_div = "css:div#rightPanel"
first_name_field = "css:input#customer\\.firstName"
last_name_field = "css:input#customer\\.lastName"
street_field = "css:input#customer\\.address\\.street"
city_field = "css:input#customer\\.address\\.city"
state_field = "css:input#customer\\.address\\.state"
zip_code_field = "css:input#customer\\.address\\.zipCode"
phone_field = "css:input#customer\\.phoneNumber"
ssn_field = "css:input#customer\\.ssn"
username_field = "css:input#customer\\.username"
password_field = "css:input#customer\\.password"
repeated_password_field = "css:input#repeatedPassword"
submitBtn = "css:#customerForm input[value='Register']"
user_creation_success_msg = "Your account was created successfully"
nav_links = ["link:About Us","link:Services","link:Products","link:Locations","link:Admin Page"]

#Open New Account Page
open_new_account_link = "css:a[href='openaccount.htm']"
account_type_select = "css:select#type"
open_new_account_submit_btn = "css:input[value='Open New Account']"

#Login Panel
username_login_field = "css:input[name='username']"
password_login_field = "css:input[name='password']"
login_btn = "css:#loginPanel input[type='submit']"
