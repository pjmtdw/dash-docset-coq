#!/usr/bin/env python
import argparse
from pathlib import Path
from sphinx.util.inventory import InventoryFile

def main(args):
  base_url = gen_base_url(args.objects_inv_path)
  def joinfunc(uri, location):
    return uri + '/' + location
  with open(args.objects_inv_path, 'rb') as fin:
    inv = InventoryFile.load(fin, base_url, joinfunc)
  if args.type:
    for typ in inv:
      print(typ)
  else:
    for typ, indices in inv.items():
      for _, (_, _, uri, title) in indices.items():
        print(typ, uri, title, sep='\t')

def gen_base_url(path):
  p = Path(path)
  return 'file://' + str(p.parent.absolute())

def arg_parse():
  parser = argparse.ArgumentParser(description='parse objects.inv created py Sphinx')
  parser.add_argument('objects_inv_path', help='path to objects.inv', metavar='PATH')
  parser.add_argument('-t', '--type', action='store_true', help='output directives/roles types only')
  return parser.parse_args()

if __name__ == '__main__':
  main(arg_parse())
