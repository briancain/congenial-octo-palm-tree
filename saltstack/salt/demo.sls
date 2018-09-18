/demo.txt:
  file.managed:
    - contents: {{ pillar['demo'] }}
