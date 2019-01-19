#!/usr/bin/env python
import sys
from pathlib import Path
import sqlite3

def main():
  resource_path = Path(sys.argv[1]) / 'Contents' / 'Resources'
  conn = sqlite3.connect(resource_path / 'docSet.dsidx')
  cursor = conn.cursor()
  doc_base = resource_path / 'Documents'
  delete_ids = []
  for row in cursor.execute('SELECT id,path FROM searchIndex'):
    doc_id, path = row
    path = path.split('#')[0]
    doc_path = doc_base / path
    if not doc_path.exists():
      delete_ids.append(doc_id)
  for doc_id in delete_ids:
    cursor.execute('DELETE FROM searchIndex WHERE id = ?', (doc_id,))
  conn.commit()
  conn.close()

if __name__ == '__main__':
  main()
