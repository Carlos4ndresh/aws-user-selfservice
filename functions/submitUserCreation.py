import boto3
import logging
import random
import string


logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    username = event['username']
    user_email = event['useremail']
    user_location = event['location']
    user_project = event['project']
    # user_pwd = event['userpwd']

    tags = [{'Key': 'UserEmail', 'Value': user_email},
            {'Key': 'Location', 'Value': user_location},
            {'Key': 'Project', 'Value': user_project}]

    iam_client = boto3.client('iam')
    logger.info("****USERS ADDED*****:" + username)
    response = iam_client.create_user(UserName=username, Tags=tags)
    logger.info(response)
    logger.info(generate_password(username))
    return "User Created: "+username


def random_password(stringLength):
    alphabet = string.ascii_letters
    password = random.choice(string.ascii_lowercase)
    password += random.choice(string.ascii_uppercase)
    password += random.choice(string.digits)
    password += random.choice("," + "!" + "?" + "*")
    for i in range(stringLength):
        password += random.choice(alphabet)
    passwordList = list(password)
    random.SystemRandom().shuffle(passwordList)
    password = ''.join(passwordList)
    return password


def generate_password(user):
    iam_client = boto3.resource('iam')
    login_profile = iam_client.LoginProfile(user)
    password = random_password(14)
    returned_profile = login_profile.create(
        Password=password, PasswordResetRequired=True)
    return returned_profile


# Future queue or DynamoDB to queue
def put_message_in_queue(message):
    pass
