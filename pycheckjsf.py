#!/usr/bin/env python3
import requests
import sys, re
from urllib3.exceptions import InsecureRequestWarning

# Disable the InsecureRequestWarning
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)

RED = "\033[0;31m"
GREEN = "\033[0;32m"
NC = "\033[0m"

def printrn(text):
    print(f"{RED}{text}{NC}")

def printgn(text):
    print(f"{GREEN}{text}{NC}")

if len(sys.argv) < 2:
    print("Usage: <http[s]://server/path/javax.faces.resource/[folder/]file.jsf [<optional_cookie_value>]")
    sys.exit(-1)

mycookie = ""
if len(sys.argv) > 2:
    mycookie = sys.argv[2]

def check_url(url,showMsg=True):
    try:
        response = requests.get(url, cookies={mycookie: mycookie}, verify=False)
        if response.status_code == 200:
            if showMsg:
                printgn("YES")
            return True
        else:
            if showMsg:
                printrn("NO")
            return False
    except:
        if showMsg:
                printrn("NO")
        return False

def qprint(text):
    print(f"{text:<90}", end="")

jsfurl = sys.argv[1]

print("\nJSF Version Checker v0.4 by sectroyer\n")

qprint("Checking if url is ok...")
if not check_url(jsfurl):
    print("Provided url doesn't work :(")
    sys.exit(-1)

if "ln=" in jsfurl:
    print("\nDetected complex url. Normalizing...\n")
    ln_param = re.search("ln=([^&]*)", jsfurl).group(1)
    ln_value = ln_param.replace("ln=", "")
    jsfurl = jsfurl.replace(ln_param, "").replace("faces.resource", f"faces.resource@{ln_value}")
    if jsfurl[-1] == "?":
        jsfurl = jsfurl[:-1]
    print(f"Normalized url: {jsfurl}\n")
    qprint("Checking if normalized url is ok...")
    if not check_url(jsfurl):
        print("Normalized url doesn't work :(")
        sys.exit(-1)

jsf_base = re.search(".*javax.faces.resource/", jsfurl).group()

print(f"\nJSF Base: {jsf_base}\n")

qprint("Checking if jsf.js exists...")
myjs_url = f"{jsf_base}jsf.js.jsf?ln=javax.faces"
if not check_url(myjs_url):
    sys.exit(-1)

print("")
qprint("Checking if we are dealing with Apache MyFaces...")
myfaces_url = f"{jsfurl}?ln=."
does_dot_work = check_url(myfaces_url,False)
does_dot_slash_work = check_url(f"{jsfurl}?ln=./.",False)
if does_dot_work and not does_dot_slash_work:
    printgn("YES")
    print("Apache MyFaces detected...")
    sys.exit(0)
else:
	printrn("NO");

print("\nMojarra detected :)\n")

qprint("Checking if Mojarra version is 2.3.0 or higher...")
myjs_url = f"{jsf_base}jsf.js.jsf?loc=javax.faces"
is_2_3 = check_url(myjs_url)

print("")
qprint("Checking if Mojarra version is in range 2.3.0-2.3.13...")
#mojarra_url = f"{jsfurl}/resource/resource/resources?loc=./.."
mojarra_url = jsfurl.replace("resource","resource/resources")+"?loc=./.."
if not check_url(mojarra_url):
    if is_2_3:
        print("\nMojarra version is higher than 2.3.13 :(\n")
        exit(-1)
    else:
        print("\nMojarra version is higher than 2.3.13 or lower than 2.3.0 :(\n")
else:
    print("\nMojarra version is in range 2.3.0-2.3.13 :D\n")
    exit(0)

qprint("Checking if Mojarra version is lower than 2.2.7...")
mojarra_url = f"{jsfurl}?ln=."
if not check_url(mojarra_url):
    print("\nMojarra version is higher than 2.2.6\n")
    exit(-1)

print("\nMojarra version is lower than 2.2.7 :D\n")

qprint("Checking if Mojarra version is lower than 2.2.5...")
mojarra_url = jsfurl.replace("resource","resource/resources")+"?ln=./.."
#mojarra_url = f"{jsfurl}/resource/resource/resources?ln=./.."
if not check_url(mojarra_url):
    print("\nMojarra version is higher than 2.2.4 :)\n")
    exit(0)

print("\nMojarra version is lower than 2.2.5 :D\n")
print("")

