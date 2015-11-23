#!/usr/bin/python

import os
import glob

def get_ipa():
	ipa = os.environ.get("XCS_OUTPUT_DIR", None)

	if not ipa:
		exit(1)

	if ipa:
		ipa = glob.glob(ipa+"/*.ipa")

	if len(ipa) != 1:
		exit(1)

	return ipa[0]

current = os.path.dirname(os.path.realpath(__file__))
cert = current + "/certs/PUT_PEM_NAME_HERE.pem"
command = "scp -r -i %s -P 999 -o StrictHostKeyChecking=no %s developer@SERVER_NAME:/var/users/developer/temp/APP_NAME.ipa" % (cert, get_ipa())
print command
print os.popen(command).read()
print "success"
exit(0)
