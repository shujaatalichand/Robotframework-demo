import requests

class Parabanklib:
    ROBOT_LIBRARY_VERSION = '1.0'
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    def create_user(self,user_dict,url):
        target_url = f"{url.rstrip('/')}/register.htm"
        headers = {
        'Accept': 'text/html,application/xhtml+xml,application/xml'
        }
        form_data = {
            'customer.firstName': user_dict['first_name'],
            'customer.lastName': user_dict['last_name'],
            'customer.address.street': user_dict['street'],
            'customer.address.city': user_dict['city'],
            'customer.address.state': user_dict['state'],
            'customer.address.zipCode': user_dict['zip_code'],
            'customer.phoneNumber': user_dict['phone'],
            'customer.ssn': user_dict['ssn'],
            'customer.username': user_dict['username'],
            'customer.password': user_dict['password'],
            'repeatedPassword': user_dict['password'],
        }
        session = requests.Session()
        session.get(target_url, headers=headers)
        response = session.post(target_url, data=form_data, headers=headers)