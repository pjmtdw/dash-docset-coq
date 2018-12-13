FROM ubuntu:18.04

# camlp5 might not be required from future coq
RUN apt-get update && apt-get install -y --no-install-recommends \
      make ocaml ocaml-findlib python3 python3-setuptools python3-pip camlp5

# actually we don't need sphinx_rtd_theme==0.4.2, since we will use alabaster theme instead
RUN pip3 install 'Sphinx==1.8.2' 'sphinx_rtd_theme==0.4.2' 'sphinxcontrib-bibtex==0.4.1' \
      'beautifulsoup4==4.6.3' 'pexpect==4.6.0' 'antlr4-python3-runtime==4.7.1' 'doc2dash==2.3.0'

ADD https://github.com/coq/coq/archive/V8.9+beta1.tar.gz coq.tar.gz
RUN mkdir /coq && tar zxf coq.tar.gz -C /coq --strip-components=1

COPY coq_parser.py /coq/

WORKDIR /coq

# consider using -no-ask option which is added in recent coq, instead of specifing all options
RUN ./configure -prefix /usr -mandir /usr/share/man -configdir /etc/xdg/coq/ -coqide no -with-doc yes 

# Default sphinx theme for coq which is sphinx_rtd_theme, seems no way to disable sidebar, so we use alabaster instead
RUN make -j4 SPHINXOPTS="-Dhtml_theme=alabaster -Dhtml_theme_options.nosidebar=true" doc-html

RUN LANG=C.UTF-8 LC_ALL=C.UTF-8 PYTHONPATH=. doc2dash -n Coq -i ./ide/coq.png \
         --parser coq_parser.CoqSphinxParser ./doc/sphinx/_build/html
