from doc2dash.parsers.intersphinx import InterSphinxParser

# Sphinx Directive -> Dash Entry Type
# Read ./docs/dash_zeal_type.md for types supported by Dash and Zeal
# You can figure out which directive Coq uses can be listed using ./tools/parse_objects_inv.py
TYPE_MAP = {
    'coq:cmd': 'Command',
    'coq:cmdv': 'Variable',
    'coq:exn': 'Error',
    'coq:flag': 'Flag',
    'coq:index': 'Index',
    'coq:opt': 'Option',
    'coq:table': 'Table',
    'coq:tacn': 'Tactic',
    'coq:tacv': 'Variant',
    'coq:warn': 'Warn',
    'std:doc': 'Guide',
    'std:label': 'Section',
    'std:token': 'Keyword'
}

class CoqSphinxParser(InterSphinxParser):
  def convert_type(self, inv_type):
    return TYPE_MAP.get(inv_type)
