from doc2dash.parsers.intersphinx import InterSphinxParser

# Sphinx Index Type -> Dash Entry Type
# Supported Entry Types
#    Dash: https://kapeli.com/docsets#supportedentrytypes
#          https://github.com/Kapeli/Dash-iOS/tree/master/Dash/Images.xcassets/Types
#    Zeal: https://github.com/zealdocs/zeal/blob/master/src/app/resources/zeal.qrc

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
