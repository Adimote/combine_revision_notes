import argparse
import re

parser = argparse.ArgumentParser()
parser.add_argument('title')
args = parser.parse_args()
title = args.title
title = re.sub('_',r'\_',title)
print(f"""
\\begin{{document}}
\\title{{{title}}}
\\end{{document}}
""")
