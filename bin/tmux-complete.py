#!/usr/bin/python

import os
import re
import subprocess
import sys

def get_output(command):
  process = subprocess.Popen(command,
                             stdout = subprocess.PIPE,
                             stderr = subprocess.PIPE)
  output, errors = process.communicate()
  return output

def get_sessions():
  output = get_output(['/usr/bin/tmux', 'list-sessions'])
  sessions = [re.sub('(\.\d+)?:.*$', '', line) for line in output.split('\n')
              if line.find('window') > 0]
  return sorted(list(frozenset(sessions)))

def get_depot_directories():
  output = get_output(['/bin/bash', '-c', 'ls $DEPOT'])
  return sorted([dir for dir in output.split('\n') if dir])

def print_options(command, prefix):
  prefixed = lambda names: [name for name in names
                            if not prefix or name.startswith(prefix)]
  if command == 'rsc':
    sessions = prefixed(get_sessions())
    print '\n'.join(sessions)
  elif command == 'mksc':
    depot_dirs = prefixed(get_depot_directories())
    sessions = frozenset(get_sessions())
    depot_dirs = [dir for dir in depot_dirs if dir not in sessions]
    print '\n'.join(depot_dirs)

def main():
  if len(sys.argv) > 1:
    command = sys.argv[1]
    prefix = None
    if len(sys.argv) > 2:
      prefix = sys.argv[2]
    print_options(command, prefix)
  else:
    print '[Depot]'
    sessions = frozenset(get_sessions())
    for dir in get_depot_directories():
      if dir not in sessions:
        print '  mksc %s' % dir
    print
    print '[Live Sessions]'
    for session in get_sessions():
      print '  rsc %s' % session
    print

if __name__ == '__main__':
  try:
    main()
  except:
    pass
