import string
import random

characters = list(string.ascii_letters + string.digits + "!@#$%^&*()")

def lambda_handler(event, context):

    #Number of characters in the password
	length = 16
	random.shuffle(characters)
	
	password = []
	for i in range(length):
		password.append(random.choice(characters))

    #Shuffle the resultant password 
	random.shuffle(password)

    #Return the resultant password
	return("".join(password))
