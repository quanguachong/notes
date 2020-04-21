# sphinx

```bash
$ sphinx-quickstart
$ mkdir html rst t9k
$ cp -r /Users/czx/modgo/pipeline-sdk/t9k/* t9k/
$ sed -i "s/extensions = \[$/extensions = \[\'sphinx.ext.autodoc\'/g" conf.py 
$ sphinx-apidoc -o rst/ t9k/
```