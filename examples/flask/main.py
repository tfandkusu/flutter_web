from flask import Flask
from flask import jsonify
from flask import abort
from flask import render_template
from card import Card
import maker
import json


app = Flask(__name__)
app.config['JSON_SORT_KEYS'] = False
app.config['JSON_AS_ASCII'] = False
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
# 名刺一覧を作る
cards = maker.make()

@app.route('/')
def root():
    # index.htmlはtemplatesディレクトリに置く
    return render_template('index.html')

@app.route('/cards')
def list_cards():
    "名刺一覧を返却"
    ja = []
    for card in cards:
        ja.append(card.__dict__)
    return jsonify(ja)

@app.route('/cards/<int:id>')
def show_card(id):
    "名刺1枚を返却"
    if 1 <= id and id <= len(cards):
        card = cards[id - 1]
        return jsonify(card.__dict__)
    else:
        abort(404)

if __name__ == '__main__':
    # ローカルテスト環境
    @app.after_request
    def add_cross_origin_header(response):
        # 8080はFlutter Webのポート番号
        response.headers['Access-Control-Allow-Origin'] = 'http://localhost:8080'
        return response
    # Flaskはポート番号5000で起動
    app.run(host='127.0.0.1', port=5000, debug=True)
