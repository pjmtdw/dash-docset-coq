#!/usr/bin/env python
import re
import sqlite3
from argparse import ArgumentParser
from collections import defaultdict
from pathlib import Path
from bs4 import BeautifulSoup

def count_html_words(path):
  with open(path) as fin:
    soup = BeautifulSoup(fin, features='html5lib')
  return len(re.split(r'\s', soup.text))

def main(args):
  docset_path = Path(args.docset_path)
  resource_path = docset_path / 'Contents' / 'Resources'
  conn = sqlite3.connect(resource_path / 'docSet.dsidx')
  cursor = conn.cursor()
  counts = defaultdict(lambda: 0)
  for row in cursor.execute('SELECT path FROM searchIndex'):
    counts[row[0].split('#')[0]] += 1
  doc_path = Path(resource_path / 'Documents')
  for html in doc_path.glob('./**/*.html'):
    relpath = html.relative_to(doc_path)
    if str(relpath) in counts:
      words = count_html_words(html)
      c = counts[str(relpath)]
      print('EXISTS', c, words//c, relpath, sep='\t')
      del counts[str(relpath)]
    else:
      print('NOT_IN_DB', 0, 0, relpath, sep='\t')
  for key, value in counts.items():
    print('ONLY_IN_DB', value, 0, key, sep='\t')

def arg_parse():
  parser = ArgumentParser(description='check Dash docset')
  parser.add_argument('docset_path', metavar='PATH', help='path to *.docset')
  return parser.parse_args()

if __name__ == '__main__':
  main(arg_parse())
