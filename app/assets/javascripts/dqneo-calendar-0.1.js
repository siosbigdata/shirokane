//  =============================================================
//  dqneo-calendar.js ---- シンプルなポップアップカレンダー
//  =============================================================

/***********************************************************
//  使用例

<html>
<head>
  <script src="dqneo-calendar.js" charset="utf-8"></script>
  <script>
    var cal1 = new DQNEO.Calendar("cal1");
  </script>
</head>

<body>

<p>テキストボックスの中をクリックしてみてください。</p>

<span>
    <input type="text" id="cal1" onclick="cal1.onclick();" onchange="cal1.onchange();"><br>
</span>


 **********************************************************/

// 親クラス

if ( typeof(DQNEO) == 'undefined' ) DQNEO = function() {};

// コンストラクタ

DQNEO.Calendar = function ( inputid, func ) {
    this.calendarid = "cal-" + inputid;
    this.inputid = inputid;
    this.__dispelem = null;  // カレンダー表示欄エレメント
    this.__textelem = null;  // テキスト入力欄エレメント
    this.style = new DQNEO.Calendar.Style();
    this.func = func;
    return this;
};

// バージョン

DQNEO.Calendar.VERSION = "0.1.0";

// デフォルトのプロパティ

DQNEO.Calendar.prototype.spliter = "-"; // 日付を文字列で持つ場合の形式。YYYY-MM-DD。
DQNEO.Calendar.prototype.date = null;
DQNEO.Calendar.prototype.min_date = null;
DQNEO.Calendar.prototype.max_date = null;


//=========================================
//            DOM操作関連
//=========================================

// カレンダー表示エリアのDOM要素

DQNEO.Calendar.prototype.getCalendarElement = function () {
    if ( this.__dispelem ) return this.__dispelem;
    var elm = document.createElement('div');

    elm.style.font = 'small/normal Arial,Sans-serif';
    elm.style.background = '#c3d9ff'; /* カンレダー上部の背景色 */
    elm.style.lineHeight = '1em'; /* この書き方であってるのか？ */
    elm.style.width = '12.45em';
    elm.style.display = 'none';
    elm.style.position = 'absolute';
    elm.style.zindex = '300';    /* この書き方であってるのか？ */

    this.getInputBox().parentNode.appendChild(elm);
    this.__dispelem = elm;

    return this.__dispelem;
};

// 日付入力用テキストボックスのDOM要素

DQNEO.Calendar.prototype.getInputBox = function () {
    if ( this.__textelem ) return this.__textelem;
    this.__textelem = document.getElementById(this.inputid);
    return this.__textelem;
};


DQNEO.Calendar.prototype.onchage = function(){
    this.setFormValue();
    this.hide();
}

DQNEO.Calendar.prototype.onclick = function(){
    if( this.getCalendarElement().style.display == 'none' ){
        this.write();
    }else{
        this.hide();
    }
}

// テキストボックスの値を取得する（ついでにオブジェクトも更新する）

DQNEO.Calendar.prototype.getFormValue = function () {
    var inputBox = this.getInputBox();
    if ( ! inputBox ) return "";
    var date1 = this.setDateYMD( inputBox.value );
    return date1;
};

//  テキストボックスに値を書き込む

DQNEO.Calendar.prototype.setFormValue = function (ymd) {
    if ( ! ymd ) ymd = this.getDateYMD();   // 無指定時はオブジェクトから？
    var inputBox = this.getInputBox();
    if ( inputBox ) inputBox.value = ymd;
};

//  カレンダー表示欄を表示する

DQNEO.Calendar.prototype.show = function () {
    this.getCalendarElement().style.display = "";
};

//  カレンダー表示欄を隠す

DQNEO.Calendar.prototype.hide = function () {
    this.getCalendarElement().style.display = "none";
};


//=========================================
//      スタイルシート関連
//=========================================


// DQNEO.Calendar.Style

DQNEO.Calendar.Style = function() {
    return this;
};

// デフォルトのスタイル

DQNEO.Calendar.Style.prototype.frame_width        = "12.45em";      // フレーム横幅
DQNEO.Calendar.Style.prototype.frame_color        = "#c3d9ff";    // フレーム枠の色
DQNEO.Calendar.Style.prototype.font_size          = "12px";       // 文字サイズ
DQNEO.Calendar.Style.prototype.day_bgcolor        = "#FFFFFF";    // カレンダーの背景色
DQNEO.Calendar.Style.prototype.month_color        = "#0000DD";    // ○年○月部分の文字色
DQNEO.Calendar.Style.prototype.month_hover_color  = "#009900";    // マウスオーバー時の≪≫文字色
DQNEO.Calendar.Style.prototype.month_hover_bgcolor = "#FFFFCC";   // マウスオーバー時の≪≫背景色
DQNEO.Calendar.Style.prototype.weekday_color      = "#000";       // 月曜～金曜日セルの文字色
DQNEO.Calendar.Style.prototype.weekday_bgcolor    = "#fff";       // 月曜～金曜日セルの背景色
DQNEO.Calendar.Style.prototype.weekend_bgcolor    = "#eee";       // 土曜日セルの文字色
DQNEO.Calendar.Style.prototype.offmonth_color       = "#bbbbbb";  // 他の月の日セルの文字色
DQNEO.Calendar.Style.prototype.day_hover_bgcolor  = "#99bbFF";    // マウスオーバー時の日セルの背景
DQNEO.Calendar.Style.prototype.cursor             = "pointer";    // マウスオーバー時のカーソル形状うに。

//  メソッド

DQNEO.Calendar.Style.prototype.set = function(key,val) { this[key] = val; }
DQNEO.Calendar.Style.prototype.get = function(key    ) { return this[key]; }
DQNEO.Calendar.prototype.setStyle  = function(key,val) { this.style.set(key,val); };
DQNEO.Calendar.prototype.getStyle  = function(key    ) { return this.style.get(key); };

//=========================================
//               日付関連の処理
//=========================================
// 日付を初期化する

DQNEO.Calendar.prototype.initDate = function ( dd ) {
    if ( ! dd ) dd = new Date();
    var year = dd.getFullYear();
    var mon  = dd.getMonth();
    var date = dd.getDate();
    this.date = new Date( year, mon, date );
    this.getFormValue(); //ここはわかりにくい。ゲッターをセッターとして使っている。
    return this.date;
}



// オブジェクトに日付を記憶する（YYYY/MM/DD形式で指定する）

DQNEO.Calendar.prototype.setDateYMD = function (ymd) {
    var splt = ymd.split( this.spliter );
    if ( splt[0]-0 > 0 &&
         splt[1]-0 >= 1 && splt[1]-0 <= 12 &&       // bug fix 2006/03/03 thanks to ucb
         splt[2]-0 >= 1 && splt[2]-0 <= 31 ) {
        if ( ! this.date ) this.initDate();
        this.date.setFullYear( splt[0] );
        this.date.setMonth( splt[1]-1 );
        this.date.setDate( splt[2] );
    } else {
        ymd = "";
    }
    return ymd;
};

// オブジェクトから日付を取り出す（YYYY/MM/DD形式で返る）
// 引数に Date オブジェクトの指定があれば、
// オブジェクトは無視して、引数の日付を使用する（単なるfprint機能）

DQNEO.Calendar.prototype.getDateYMD = function ( dd ) {
    if ( ! dd ) {
        if ( ! this.date ) this.initDate();
        dd = this.date;
    }
    var mm = "" + (dd.getMonth()+1);
    var aa = "" + dd.getDate();
    if ( mm.length == 1 ) mm = "" + "0" + mm;
    if ( aa.length == 1 ) aa = "" + "0" + aa;
    return dd.getFullYear() + this.spliter + mm + this.spliter + aa;
};


// 月の前後移動ボタンを押しときに再描画するメソッド

DQNEO.Calendar.prototype.onMonthMove = function ( mon ) {
    // 前へ移動
    if ( ! this.date ) this.initDate();
    for( ; mon<0; mon++ ) {
        this.date.setDate(1);   // 毎月1日の1日前は必ず前の月
        this.date.setTime( this.date.getTime() - (24*3600*1000) );
    }
    // 後へ移動
    for( ; mon>0; mon-- ) {
        this.date.setDate(1);   // 毎月1日の32日後は必ず次の月
        this.date.setTime( this.date.getTime() + (24*3600*1000)*32 );
    }
    this.date.setDate(1);       // 当月の1日に戻す
    this.write();    // 描画する
};

// イベントを登録する

DQNEO.Calendar.prototype.addEvent = function ( elem, ev, func ) {
//  prototype.js があれば利用する(IEメモリリーク回避)
    if ( window.Event && Event.observe ) {
        Event.observe( elem, ev, func, false );
    } else {
        elem["on"+ev] = func;
    }
}

//=========================================
//           カレンダーを描画する
//=========================================

DQNEO.Calendar.prototype.write = function () {
    var date = new Date();
    if ( ! this.date ) this.initDate();
    date.setTime( this.date.getTime() );

    var year = date.getFullYear();          // 指定年
    var mon  = date.getMonth();             // 指定月
    var today = date.getDate();             // 指定日

    // 選択可能な日付範囲
    var min;
    if ( this.min_date ) {
        var tmp = new Date( this.min_date.getFullYear(), 
            this.min_date.getMonth(), this.min_date.getDate() );
        min = tmp.getTime();
    }
    var max;
    if ( this.max_date ) {
        var tmp = new Date( this.max_date.getFullYear(), 
            this.max_date.getMonth(), this.max_date.getDate() );
        max = tmp.getTime();
    }

    // 直前の月曜日まで戻す
    date.setDate(1);                        // 1日に戻す
    var wday = date.getDay();               // 曜日 日曜(0)～土曜(6)
    if ( wday != 1 ) {
        if ( wday == 0 ) wday = 7;
        date.setTime( date.getTime() - (24*3600*1000)*(wday-1) );
    }

    // 最大で7日×6週間＝42日分の日付オブジェクトを格納した配列を生成
    var list = new Array();
    for( var i=0; i<42; i++ ) {
        var tmp = new Date();
        tmp.setTime( date.getTime() + (24*3600*1000)*i );
        if ( i && i%7==0 && tmp.getMonth() != mon ) break;
        list.push(tmp);
    }
    

    // HTMLソースを生成する

    var html_table_header = this.makeTableHeader(year,mon);
    var html_table_body   = this.makeTableBody(mon,list,min, max);

    // カレンダーを描画
    var cal1 = this.getCalendarElement();
    if ( ! cal1 ) return;
    cal1.innerHTML = html_table_header + html_table_body;

    // 表示する
    this.show();

    //個々のセルにイベントハンドラを登録する。
    this.registerEvents(list,min,max);
    
}

DQNEO.Calendar.prototype.registerEvents = function(list, min, max){

    // イベントを登録する
    var __this = this;
    var get_src = function (ev) {
        ev  = ev || window.event;
        var src = ev.target || ev.srcElement;
        return src;
    };
    var month_onmouseover = function (ev) {
        var src = get_src(ev);
        src.style.color = __this.style.month_hover_color;
        src.style.background = __this.style.month_hover_bgcolor;
    };
    var month_onmouseout = function (ev) {
        var src = get_src(ev);
        src.style.color = __this.style.month_color;
        src.style.background = __this.style.frame_color;
    };
    var day_onmouseover = function (ev) {
        var src = get_src(ev);
        src.style.background = __this.style.day_hover_bgcolor;
    };
    var day_onmouseout = function (ev) {
        var src = get_src(ev);
        src.style.background = __this.style.weekday_bgcolor;
    };

    var weekend_onmouseout = function (ev) {
        var src = get_src(ev);
        src.style.background = __this.style.weekend_bgcolor;
    };

    var day_onclick = function (ev) {
        var src = get_src(ev);
        var srcday = src.id.substr(src.id.length-10);
        __this.setFormValue( srcday );
        __this.hide();
        if( __this.func ) __this.func();    //この行は追加されたもの。コールバック関数を呼び出し。
    };

    // 前の月へボタン
    var tdprev = document.getElementById( "__"+this.calendarid+"_btn_prev" );
    tdprev.style.cursor = this.style.cursor;
    this.addEvent( tdprev, "mouseover", month_onmouseover );
    this.addEvent( tdprev, "mouseout", month_onmouseout );
    this.addEvent( tdprev, "click", function(){ __this.onMonthMove( -1 ); });

    // 閉じるボタン
    var tdclose = document.getElementById( "__"+this.calendarid+"_btn_close" );
    tdclose.style.cursor = this.style.cursor;
    this.addEvent( tdclose, "mouseover", month_onmouseover );
    this.addEvent( tdclose, "mouseout", month_onmouseout );
    this.addEvent( tdclose, "click", function(){ __this.hide(); });

    // 次の月へボタン
    var tdnext = document.getElementById( "__"+this.calendarid+"_btn_next" );
    tdnext.style.cursor = this.style.cursor;
    this.addEvent( tdnext, "mouseover", month_onmouseover );
    this.addEvent( tdnext, "mouseout", month_onmouseout );
    this.addEvent( tdnext, "click", function(){ __this.onMonthMove( +1 ); });

    // セルごとのイベントを登録する
    for ( var i=0; i<list.length; i++ ) {
        var dd = list[i];

        var utc = dd.getTime();
        if ( min && min > utc ) continue;           // 昔過ぎる
        if ( max && max < utc ) continue;           // 未来過ぎる
        if ( utc == this.getCurUTC() ) continue;              // フォーム上の当日

        var ss = this.getDateYMD(dd);
        var cc = document.getElementById( "__"+this.calendarid+"_td_"+ss );
        if ( ! cc ) continue;

        cc.style.cursor = this.style.cursor;
        this.addEvent( cc, "mouseover", day_onmouseover );
        this.addEvent( cc, "click", day_onclick );

        if( this.isWeekend(dd) ){
            this.addEvent( cc, "mouseout", weekend_onmouseout );
        }else{
            this.addEvent( cc, "mouseout", day_onmouseout );
        }
    }

};

DQNEO.Calendar.prototype.isWeekend = function(dd){
    var ww = dd.getDay();
    return ( ww == 0 || ww == 6 );
}

// HTML文を生成する。(カレンダー上部の年月、曜日の部分)
DQNEO.Calendar.prototype.makeTableHeader = function(year,mon){
    // スタイルシートを生成する
    var month_table_style = 'width: 100%; ';
    month_table_style += 'background: '+this.style.frame_color+'; ';
    month_table_style += 'border: 1px solid '+this.style.frame_color+';';

    var week_table_style = 'width: 100%; ';
    week_table_style += 'background: '+this.style.frame_color+'; ';


    var month_td_style = "";
    month_td_style += 'font-size: '+this.style.font_size+'; ';
    month_td_style += 'color: '+this.style.month_color+'; ';
    month_td_style += 'padding: 4px 0px 2px 0px; ';
    month_td_style += 'text-align: center; ';
    month_td_style += 'font-weight: bold;';

    var week_td_style = "";
    week_td_style += 'font-size: '+this.style.font_size+'; ';
    week_td_style += 'padding: 2px 0px 2px 0px; ';
    week_td_style += 'font-weight: bold;';
    week_td_style += 'text-align: center;';


    // HTML生成

    var html = '\
<table class="transparent" cellspacing="0" style="'+month_table_style+'">\
<tr>\
<td id="__'+this.calendarid+'_btn_prev" title="前の月へ" style="'+month_td_style+'">≪</td>\
<td colspan="4" style="'+month_td_style+'">'+(year)+'年 '+(mon+1)+'月</td>\
<td id="__'+this.calendarid+'_btn_next" title="次の月へ" style="'+month_td_style+'">≫</td>\
<td id="__'+this.calendarid+'_btn_close" title="閉じる" style="'+month_td_style+'">×</td>\
</tr>\
<tr>\
<td style="color: '+this.style.weekday_color+'; '+week_td_style+'">月</td>\
<td style="color: '+this.style.weekday_color+'; '+week_td_style+'">火</td>\
<td style="color: '+this.style.weekday_color+'; '+week_td_style+'">水</td>\
<td style="color: '+this.style.weekday_color+'; '+week_td_style+'">木</td>\
<td style="color: '+this.style.weekday_color+'; '+week_td_style+'">金</td>\
<td style="color: '+this.style.weekday_color+'; '+week_td_style+'">土</td>\
<td style="color: '+this.style.weekday_color+'; '+week_td_style+'">日</td>\
</tr>\
';

    
    return html;
    
    
}

// HTML文を生成する。(カレンダー下部の日の部分)
DQNEO.Calendar.prototype.makeTableBody = function (mon, list, min, max ){

    var days_unselectable = "font-weight: normal;";

    var days_td_style = "";
    days_td_style += 'font-size: '+this.style.font_size+'; ';
    days_td_style += 'padding: 3px; ';
    days_td_style += 'text-align: center; ';

    

    var tds = [];

    for ( var i=0; i<list.length; i++ ) {
        var td = '';
        var dd = list[i];
        var ww = dd.getDay();
        var mm = dd.getMonth();
        if ( ww == 1 ) {
            td += "<tr>";                                     // 月曜日の前に行頭
        }
        var cc = days_td_style;

        if ( this.isWeekend(dd) ) {
            cc += "background: "+this.style.weekend_bgcolor+";";    // 当月の土日
        } else {
            cc += "background: "+this.style.weekday_bgcolor+";";   // 当月の平日
        }

        if ( mon != mm ) {
            cc += "color: "+this.style.offmonth_color+";";        // その月に属さない日
        }

        var utc = dd.getTime();
        if (( min && min > utc ) || ( max && max < utc )) {
            cc += days_unselectable;
        }
        if ( utc == this.getCurUTC() ) {                                  // フォーム上の当日
            cc += "background: "+this.style.day_hover_bgcolor+";";
        }

        var ss = this.getDateYMD(dd);
        var tt = dd.getDate();
        td += '<td style="'+cc+'" title='+ss+' id="__'+this.calendarid+'_td_'+ss+'">'+tt+'</td>';

        if ( ww == 7 ) {
            td += "</tr>\n";                                  // 土曜日の後に行末
        }

        tds.push(td);
    }

    var html = tds.join('') + "</table>\n";
    return html;
}

DQNEO.Calendar.prototype.getCurUTC = function (){
    var inputBox = this.getInputBox();
    if ( inputBox && inputBox.value ) {
        var splt = inputBox.value.split(this.spliter);
        if ( splt[0] > 0 && splt[2] > 0 ) {
            var curdd = new Date( splt[0]-0, splt[1]-1, splt[2]-0 );
            return curdd.getTime();                           // フォーム上の当日
        }
    }
    
}
