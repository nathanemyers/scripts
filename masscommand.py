#!/usr/bin/python

import argparse, re, os

parser = argparse.ArgumentParser(description='runs a command on each box')
parser.add_argument('command', action="store")
parser.add_argument('host', nargs='*')

args = parser.parse_args()
hosts = []
if args.host:
	hosts = args.host
else:
	sshconfig = open('/home/nathan/.ssh/config', 'r')
	pattern = re.compile('^host=([a-z].*)')
	for line in sshconfig:
		host = pattern.match(line)
		if host:
			hosts.append(host.group(1))

for host in hosts:
	print '=== ' + host + ' ==='
	os.system('ssh ' + host + " '" + args.command + "'")
