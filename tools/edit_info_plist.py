#!/usr/bin/env python

import sys
import xml.etree.ElementTree as ET
from xml.etree.ElementTree import Element, fromstring

def main():
  filename = sys.argv[1]
  tree = ET.parse(filename)
  dic: Element = tree.getroot().find("dict")
  dic.append(fromstring("<key>dashIndexFilePath</key>"))
  dic.append(fromstring("<string>index.html</string>"))
  tree.write(filename)

if __name__ == "__main__":
  main()
