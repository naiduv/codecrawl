<!DOCTYPE html>
<html lang='ja'>
  <head>
    <meta charset='utf-8'>
    <title>trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb - Milkode</title>
    <link href='/css/bootstrap.min.css' media='all' rel='stylesheet' type='text/css'>
    <link href='/css/bootstrap-responsive.min.css' media='all' rel='stylesheet' type='text/css'>
    <link href='/css/milkode.css' media='all' rel='stylesheet' type='text/css'>
    <link href='/css/coderay.css' media='all' rel='stylesheet' type='text/css'>
    <link href='/css/coderay-patch.css' media='all' rel='stylesheet' type='text/css'>
    <link href='/css/smoothness/jquery-ui-1.8.22.custom.css' media='all' rel='stylesheet' type='text/css'>
    <link href='/css/jquery.multiselect.css' media='all' rel='stylesheet' type='text/css'>
    <link href='/css/jquery.multiselect.filter.css' media='all' rel='stylesheet' type='text/css'>
  </head>
  <body>
    <div class='container-fluid' id='mainpage'>
      <div class='header'>
  <h1>
    <a href="/"><img src=/images/MilkodeIcon135.png alt="milkode-icon-mini" border="0" height="75px"/></a>
    Milkode
        <img alt='' style='vertical-align:center; border: 0px; margin: 0px;' src='/images/go-home-5.png'> <a href="/home" class="headmenu">ホーム</a>
    <img alt='' style='vertical-align:center; border: 0px; margin: 0px;' src='/images/document-new-4.png'> <a href="/home/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb" class="headmenu" onclick="window.open('/home/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb'); return false;">タブを複製</a>
    <img alt='' style='vertical-align:center; border: 0px; margin: 0px;' src='/images/directory.png'> <a href="/home/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb/.." class="headmenu">ディレクトリ</a> 
    <img alt='' style='vertical-align:center; border: 0px; margin: 0px;' src='/images/view-refresh-4.png'> <a href="#updateModal" class="headmenu" data-toggle="modal">パッケージを更新</a>
    <img alt='' style='vertical-align:center; border: 0px; margin: 0px;' src='/images/help.png'> <a href="/help" class="headmenu">ヘルプ</a>

    <div id="updateModal" class="modal hide fade">
      <div class="modal-header">
        <a href="#" class="close" data-dismiss="modal">&times;</a>
        <h3>パッケージを更新</h3>
      </div>
      <div class="modal-body">
        <h4>trunk を更新しますか？</h4>
      </div>
      <div class="modal-footer">
        <a href="#" id="updateCancel" class="btn" data-dismiss="modal">Cancel</a>
        <a href="#" id="updateOk" class="btn btn-primary" data-loading-text="Updating..." milkode-package-name="trunk"">OK</a>
      </div>
    </div>

    <div id="lineno-modal" class="modal hide">
      <div class="modal-header">
        <a href="#" class="close" data-dismiss="modal">&times;</a>
        <h3 id="lineno-path"></h3>
      </div>
      <div class="modal-body">
        <table class="CodeRay"><tr>
          <td class="code"><pre id="lineno-body">
          </pre></td>
        </tr></table>
    </div>
      <div class="modal-footer">
        <a href="#" id="lineno-ok" class="btn" data-dismiss="modal">OK</a>
      </div>
    </div>
  </h1>
</div>
<div class='content'>
  <div class='search_form'>
    <script>
      //<![CDATA[
        function set_pathname() {
          document.searchform.pathname.value = location.pathname;
        }
      //]]>
    </script>
    <form action='/search' method='post' name='searchform'>
      <p>
        <input id='query' name='query' size='70' style='width: 419px;' type='text'>
        <input id='search' name='search' onclick='set_pathname()' type='submit' value='検索'>
        <input id='clear' name='clear' onclick='set_pathname()' type='submit' value='クリア'>
        <br>
        範囲:
        <select name="shead" id="shead">
        ["<option value='all' >全て</option>", "<option value='package' selected>パッケージ</option>", "<option value='directory' >ディレクトリ</option>"]
        </select>
        パッケージ:
        <select name="package" id="package" onchange="select_package()">
        ["<option value='---' >---</option>", "<option value='trunk' selected>trunk</option>"]
        </select>
        <label class='checkbox inline'><input type='checkbox' name='onematch' value='on' />1ファイル1マッチ</label>
        <label class='checkbox inline'><input type='checkbox' name='sensitive' value='on' />大文字／小文字を区別</label>
        <input name='pathname' type='hidden' value=''>
      </p>
    </form>
  </div>
  <div class='search-summary'>
    <span class="keyword"><a id='topic_0' href='/home' onclick='topic_path("topic_0");'>home</a>/<a id='topic_1' href='/home/trunk' onclick='topic_path("topic_1");'>trunk</a>/<a id='topic_2' href='/home/trunk/test' onclick='topic_path("topic_2");'>test</a>/<a id='topic_3' href='/home/trunk/test/unit' onclick='topic_path("topic_3");'>unit</a>/<a id='topic_4' href='/home/trunk/test/unit/lib' onclick='topic_path("topic_4");'>lib</a>/<a id='topic_5' href='/home/trunk/test/unit/lib/redmine' onclick='topic_path("topic_5");'>redmine</a>/<a id='topic_6' href='/home/trunk/test/unit/lib/redmine/field_format' onclick='topic_path("topic_6");'>field_format</a>/<a id='topic_7' href='/home/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb' onclick='topic_path("topic_7");'>numeric_format_test.rb</a></span>（0.004759705秒）
  </div>
  <table class="CodeRay"><tr>
  <td class="line-numbers" title="double click to toggle" ondblclick="with (this.firstChild.style) { display = (display == '') ? 'none' : '' }"><pre><a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '1');" title="Display line number">1</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '2');" title="Display line number">2</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '3');" title="Display line number">3</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '4');" title="Display line number">4</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '5');" title="Display line number">5</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '6');" title="Display line number">6</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '7');" title="Display line number">7</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '8');" title="Display line number">8</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '9');" title="Display line number">9</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '10');" title="Display line number">10</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '11');" title="Display line number">11</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '12');" title="Display line number">12</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '13');" title="Display line number">13</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '14');" title="Display line number">14</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '15');" title="Display line number">15</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '16');" title="Display line number">16</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '17');" title="Display line number">17</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '18');" title="Display line number">18</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '19');" title="Display line number">19</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '20');" title="Display line number">20</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '21');" title="Display line number">21</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '22');" title="Display line number">22</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '23');" title="Display line number">23</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '24');" title="Display line number">24</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '25');" title="Display line number">25</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '26');" title="Display line number">26</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '27');" title="Display line number">27</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '28');" title="Display line number">28</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '29');" title="Display line number">29</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '30');" title="Display line number">30</a>&#x000A;<a href="#lineno-modal" data-toggle="modal" onclick="lineno_setup('/trunk/test/unit/lib/redmine/field_format/numeric_format_test.rb:', '31');" title="Display line number">31</a></pre></td>
  <td class="code"><pre><span id="n1"><span class="comment"># Redmine - project management software</span></span>&#x000A;<span id="n2"><span class="comment"># Copyright (C) 2006-2014  Jean-Philippe Lang</span></span>&#x000A;<span id="n3"><span class="comment">#</span></span>&#x000A;<span id="n4"><span class="comment"># This program is free software; you can redistribute it and/or</span></span>&#x000A;<span id="n5"><span class="comment"># modify it under the terms of the GNU General Public License</span></span>&#x000A;<span id="n6"><span class="comment"># as published by the Free Software Foundation; either version 2</span></span>&#x000A;<span id="n7"><span class="comment"># of the License, or (at your option) any later version.</span></span>&#x000A;<span id="n8"><span class="comment">#</span></span>&#x000A;<span id="n9"><span class="comment"># This program is distributed in the hope that it will be useful,</span></span>&#x000A;<span id="n10"><span class="comment"># but WITHOUT ANY WARRANTY; without even the implied warranty of</span></span>&#x000A;<span id="n11"><span class="comment"># MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the</span></span>&#x000A;<span id="n12"><span class="comment"># GNU General Public License for more details.</span></span>&#x000A;<span id="n13"><span class="comment">#</span></span>&#x000A;<span id="n14"><span class="comment"># You should have received a copy of the GNU General Public License</span></span>&#x000A;<span id="n15"><span class="comment"># along with this program; if not, write to the Free Software</span></span>&#x000A;<span id="n16"><span class="comment"># Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.</span></span>&#x000A;<span id="n17"></span>&#x000A;<span id="n18">require <span class="constant">File</span>.expand_path(<span class="string"><span class="delimiter">'</span><span class="content">../../../../../test_helper</span><span class="delimiter">'</span></span>, <span class="predefined-constant">__FILE__</span>)</span>&#x000A;<span id="n19">require <span class="string"><span class="delimiter">'</span><span class="content">redmine/field_format</span><span class="delimiter">'</span></span></span>&#x000A;<span id="n20"></span>&#x000A;<span id="n21"><span class="keyword">class</span> <span class="class">Redmine::NumericFieldFormatTest</span> &lt; <span class="constant">ActionView</span>::<span class="constant">TestCase</span></span>&#x000A;<span id="n22">  include <span class="constant">ApplicationHelper</span></span>&#x000A;<span id="n23"></span>&#x000A;<span id="n24">  <span class="keyword">def</span> <span class="function">test_integer_field_with_url_pattern_should_format_as_link</span></span>&#x000A;<span id="n25">    field = <span class="constant">IssueCustomField</span>.new(<span class="symbol">:field_format</span> =&gt; <span class="string"><span class="delimiter">'</span><span class="content">int</span><span class="delimiter">'</span></span>, <span class="symbol">:url_pattern</span> =&gt; <span class="string"><span class="delimiter">'</span><span class="content">http://foo/%value%</span><span class="delimiter">'</span></span>)</span>&#x000A;<span id="n26">    custom_value = <span class="constant">CustomValue</span>.new(<span class="symbol">:custom_field</span> =&gt; field, <span class="symbol">:customized</span> =&gt; <span class="constant">Issue</span>.new, <span class="symbol">:value</span> =&gt; <span class="string"><span class="delimiter">&quot;</span><span class="content">3</span><span class="delimiter">&quot;</span></span>)</span>&#x000A;<span id="n27"></span>&#x000A;<span id="n28">    assert_equal <span class="integer">3</span>, field.format.formatted_custom_value(<span class="predefined-constant">self</span>, custom_value, <span class="predefined-constant">false</span>)</span>&#x000A;<span id="n29">    assert_equal <span class="string"><span class="delimiter">'</span><span class="content">&lt;a href=&quot;http://foo/3&quot;&gt;3&lt;/a&gt;</span><span class="delimiter">'</span></span>, field.format.formatted_custom_value(<span class="predefined-constant">self</span>, custom_value, <span class="predefined-constant">true</span>)</span>&#x000A;<span id="n30">  <span class="keyword">end</span></span>&#x000A;<span id="n31"><span class="keyword">end</span></span></pre></td>
</tr></table>
</div>
    </div>
    <script src='/js/jquery-1.7.2.min.js' type='text/javascript'></script>
    <script src='/js/jquery-ui-1.8.22.custom.min.js' type='text/javascript'></script>
    <script src='/js/jquery.multiselect.min.js' type='text/javascript'></script>
    <script src='/js/jquery.multiselect.filter.min.js' type='text/javascript'></script>
    <script src='/js/bootstrap.min.js' type='text/javascript'></script>
    <script src='/js/milkode.js' type='text/javascript'></script>
  </body>
</html>
