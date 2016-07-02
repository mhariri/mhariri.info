#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from flask import Flask, session, redirect, url_for, escape, request, make_response
import json
app = Flask(__name__)

data = []

@app.route('/', methods=['GET', 'POST'])
def dumper():
    if request.method == 'POST':
        data.append(format(request.json))
        return '', 200
    else:
        seen = {}
        with open('dump.json', 'w') as f:
            f.write(json.dumps(
                        sorted([seen.setdefault(x['name'], x) for x in data if x['name'] not in seen],
                            key=lambda s: [int(x) for x in s.get('vars', "0,0,0").split(",")]),
                            ensure_ascii=False,
                            indent=4))
        return "POST any data and it will be saved in dump.json " + \
                "file. Stored %d records."%len(data)

@app.after_request
def add_header(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept'
    return response

def format(d):
    d['name'] = d.get('name', '').strip()
    d['meaning'] = d.get('meaning', '').strip()
    return d

app.run('0.0.0.0', debug=True, port=5000, ssl_context='adhoc')
