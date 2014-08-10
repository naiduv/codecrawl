<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>list.rb - ThinReports Generator for Ruby - Matsukei Open Source Center</title>
<meta name="description" content="Matsukei Open Source Center" />
<meta name="keywords" content="Ruby,帳票,OSS,Rails,マツケイ" />
<meta content="authenticity_token" name="csrf-param" />
<meta content="9yjIlt7V6C1UxrvFyuWfUaOf5CTBp4ixA11ptL9JMz8=" name="csrf-token" />
<link rel='shortcut icon' href='/favicon.ico?1348113956' />
<link href="/stylesheets/jquery/jquery-ui-1.9.2.css?1372407541" media="all" rel="stylesheet" type="text/css" />
<link href="/themes/mosc/stylesheets/application.css?1375373810" media="all" rel="stylesheet" type="text/css" />


<script src="/javascripts/jquery-1.8.3-ui-1.9.2-ujs-2.0.3.js?1372407541" type="text/javascript"></script>
<script src="/javascripts/application.js?1372407541" type="text/javascript"></script>
<script type="text/javascript">
//<![CDATA[
$(window).load(function(){ warnLeavingUnsaved('このページから移動すると、保存されていないデータが失われます。'); });
//]]>
</script>

<meta property="og:url" content="http://osc.matsukei.net/attachments/189/list.rb">
<meta property="og:type" content="website">
<meta property="og:image" content="http://osc.matsukei.net/plugin_assets/redmine_mosc/images/matsukei-osc-vlogo.png">
<meta property="og:title" content="list.rb - ThinReports Generator for Ruby - Matsukei Open Source Center">
<meta property="og:description" content="Matsukei Open Source Center is Open Source Software Portal presented by Matsukei Co.,Ltd">
<meta property="og:site_name" content="Matsukei Open Source Center">
<script src="/plugin_assets/redmine_mosc/javascripts/mosc.js?1337665884" type="text/javascript"></script>

 



  <script src="/plugin_assets/redmine_wiki_extensions/javascripts/jquery.tablesorter.js?1359528837" type="text/javascript"></script>
  <link href="/plugin_assets/redmine_wiki_extensions/stylesheets/wiki_extensions.css?1337665884" media="screen" rel="stylesheet" type="text/css" />
  <script src="/plugin_assets/redmine_wiki_extensions/javascripts/wiki_extensions.js?1359528837" type="text/javascript"></script>

<!-- page specific tags -->
    <link href="/stylesheets/scm.css?1359528773" media="screen" rel="stylesheet" type="text/css" /><script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount','UA-19321975-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
</head>
<body class="theme-Mosc controller-attachments action-show project-true">
<div id="wrapper">
<div id="wrapper2">
      
<div id="header">
	<div id="mosc-header-right-contents">
      <div id="top-menu">
        
        <div id="account">
            <ul><li><a href="/login" class="login">ログイン</a></li></ul>        </div>
	    </div>
        <div style="clear:both;height:1px;margin:0;padding:0;visibility:hidden;"></div>
        <div id="quick-search">
          <form accept-charset="UTF-8" action="/projects/thinreports-generator/search" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div>
          
          <label for='q'>
            <a href="/projects/thinreports-generator/search" accesskey="4">検索</a>:
          </label>
          <input accesskey="f" class="small" id="q" name="q" size="20" type="text" />
</form>          
        </div>
	</div>
    <div id="mosc-title">
        <a href="http://osc.matsukei.net/" title="Matsukei Open Source Center"><img alt="Matsukei Open Source Center" src="/themes/mosc/images/mosc-title.png?1337659436" /></a>
    </div>
</div>

<div id="mosc-navi">
  <ul><li><a href="/news" class="news">ニュース</a></li>
<li><a href="/projects" class="projects">プロジェクト</a></li>
<li><a href="/projects/mosc/wiki/Contact" class="mosc-contact">お問合わせ</a></li>
<li><a href="/account/register" class="mosc-join">今すぐ登録</a></li>
<li><a href="/projects/mosc/wiki/About" class="mosc-about">About</a></li></ul></div>

<div id="mosc-page-header">
  <h1><a href="/projects/thinreports?jump=attachments" class="root">ThinReports</a> » ThinReports Generator for Ruby</h1>
</div>

<div id="main-menu">
    <ul><li><a href="/projects/thinreports-generator" class="overview">概要</a></li>
<li><a href="/projects/thinreports-generator/activity" class="activity">活動</a></li>
<li><a href="/projects/thinreports-generator/roadmap" class="roadmap">ロードマップ</a></li>
<li><a href="/projects/thinreports-generator/issues" class="issues">チケット</a></li>
<li><a href="/projects/thinreports-generator/news" class="news">ニュース</a></li>
<li><a href="/projects/thinreports-generator/wiki" class="wiki">Wiki</a></li>
<li><a href="/projects/thinreports-generator/repository" class="repository">リポジトリ</a></li></ul>
    <div style="clear:both;height:0;margin:0;padding:0;visibility:hidden;"></div>
</div>

<div class="" id="main">
    <div id="sidebar">
        <div id="sidebar-wrapper">
            
            <div id="mosc-fb-likebox">
  <iframe src="//www.facebook.com/plugins/like.php?href=http%3A%2F%2Fwww.facebook.com%2Fosc.matsukei&amp;send=false&amp;layout=standard&amp;width=200&amp;show_faces=false&amp;font&amp;colorscheme=light&amp;action=like&amp;height=35&amp;locale=en_US" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:200px; height:40px;" allowTransparency="true"></iframe>
</div>

<div id="mosc-sidebar-banners">
  <a href="http://www.matsukei.co.jp/" target="_blank">
    <img alt="Matsukei-banner" height="50" src="/plugin_assets/redmine_mosc/images/matsukei-banner.png?1337665884" title="Matsukei Co.,Ltd" width="200" />
  </a>
  <a href="http://www.matsukei.co.jp/service/thinreports-support/" target="_blank">
    <img alt="ThinReports 技術サポートサービス" src="/plugin_assets/redmine_mosc/images/ThinReports_Technical_Support.png?1373385676" title="ThinReports 技術サポートサービス" />
  </a>
  
</div>
<div id="mosc-sidebar-googlead">
  <script type="text/javascript">
<!--
  google_ad_client = "ca-pub-2489661226061557";
  google_ad_slot = "9228956864";
  google_ad_width = 160;
  google_ad_height = 600;
//-->
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
</div>

        </div>
    </div>
    <div id="content">
        
        <h2>list.rb</h2>

<div class="attachments">
<p>
   <span class="author"><a href="/users/3" class="user active">Katsuya Hidaka</a>, 2012/10/24 13:47</span></p>
<p><a href="/attachments/download/189/list.rb">ダウンロード</a>   <span class="size">(867 Bytes)</span></p>

</div>
&nbsp;
<div class="autoscroll">
<table class="filecontent syntaxhl">
<tbody>
  <tr>
    <th class="line-num" id="L1">
      <a href="#L1">1</a>
    </th>
    <td class="line-code">
      <pre><span class="comment"># coding: utf-8</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L2">
      <a href="#L2">2</a>
    </th>
    <td class="line-code">
      <pre>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L3">
      <a href="#L3">3</a>
    </th>
    <td class="line-code">
      <pre>require <span class="string"><span class="delimiter">'</span><span class="content">thinreports</span><span class="delimiter">'</span></span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L4">
      <a href="#L4">4</a>
    </th>
    <td class="line-code">
      <pre>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L5">
      <a href="#L5">5</a>
    </th>
    <td class="line-code">
      <pre>report = <span class="constant">ThinReports</span>::<span class="constant">Report</span>.new
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L6">
      <a href="#L6">6</a>
    </th>
    <td class="line-code">
      <pre>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L7">
      <a href="#L7">7</a>
    </th>
    <td class="line-code">
      <pre>report.use_layout <span class="string"><span class="delimiter">'</span><span class="content">list1.tlf</span><span class="delimiter">'</span></span>, <span class="symbol">:id</span> =&gt; <span class="symbol">:list1</span> <span class="keyword">do</span> |config|
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L8">
      <a href="#L8">8</a>
    </th>
    <td class="line-code">
      <pre>  config.list.use_stores <span class="symbol">:total_price</span> =&gt; <span class="integer">0</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L9">
      <a href="#L9">9</a>
    </th>
    <td class="line-code">
      <pre>  config.list.events.on <span class="symbol">:page_footer_insert</span> <span class="keyword">do</span> |e|
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L10">
      <a href="#L10">10</a>
    </th>
    <td class="line-code">
      <pre>    e.section.item(<span class="symbol">:price</span>).value(e.store.total_price)
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L11">
      <a href="#L11">11</a>
    </th>
    <td class="line-code">
      <pre>  <span class="keyword">end</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L12">
      <a href="#L12">12</a>
    </th>
    <td class="line-code">
      <pre><span class="keyword">end</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L13">
      <a href="#L13">13</a>
    </th>
    <td class="line-code">
      <pre>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L14">
      <a href="#L14">14</a>
    </th>
    <td class="line-code">
      <pre>report.use_layout <span class="string"><span class="delimiter">'</span><span class="content">list2.tlf</span><span class="delimiter">'</span></span>, <span class="symbol">:id</span> =&gt; <span class="symbol">:list2</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L15">
      <a href="#L15">15</a>
    </th>
    <td class="line-code">
      <pre>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L16">
      <a href="#L16">16</a>
    </th>
    <td class="line-code">
      <pre>report.layout(<span class="symbol">:list2</span>).config.list <span class="keyword">do</span> |list|
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L17">
      <a href="#L17">17</a>
    </th>
    <td class="line-code">
      <pre>  list.use_stores <span class="symbol">:total_count</span> =&gt; <span class="integer">0</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L18">
      <a href="#L18">18</a>
    </th>
    <td class="line-code">
      <pre>  list.events.on <span class="symbol">:page_footer_insert</span> <span class="keyword">do</span> |e|
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L19">
      <a href="#L19">19</a>
    </th>
    <td class="line-code">
      <pre>    e.section.item(<span class="symbol">:count</span>).value(e.store.total_count)
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L20">
      <a href="#L20">20</a>
    </th>
    <td class="line-code">
      <pre>  <span class="keyword">end</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L21">
      <a href="#L21">21</a>
    </th>
    <td class="line-code">
      <pre><span class="keyword">end</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L22">
      <a href="#L22">22</a>
    </th>
    <td class="line-code">
      <pre>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L23">
      <a href="#L23">23</a>
    </th>
    <td class="line-code">
      <pre>report.start_new_page <span class="symbol">:layout</span> =&gt; <span class="symbol">:list1</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L24">
      <a href="#L24">24</a>
    </th>
    <td class="line-code">
      <pre>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L25">
      <a href="#L25">25</a>
    </th>
    <td class="line-code">
      <pre><span class="integer">3</span>.times <span class="keyword">do</span> |price|
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L26">
      <a href="#L26">26</a>
    </th>
    <td class="line-code">
      <pre>  report.list.add_row <span class="symbol">:price</span> =&gt; price
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L27">
      <a href="#L27">27</a>
    </th>
    <td class="line-code">
      <pre>  report.list.store.total_price += price
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L28">
      <a href="#L28">28</a>
    </th>
    <td class="line-code">
      <pre><span class="keyword">end</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L29">
      <a href="#L29">29</a>
    </th>
    <td class="line-code">
      <pre>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L30">
      <a href="#L30">30</a>
    </th>
    <td class="line-code">
      <pre>report.start_new_page <span class="symbol">:layout</span> =&gt; <span class="symbol">:list2</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L31">
      <a href="#L31">31</a>
    </th>
    <td class="line-code">
      <pre>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L32">
      <a href="#L32">32</a>
    </th>
    <td class="line-code">
      <pre><span class="integer">3</span>.times <span class="keyword">do</span> |count|
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L33">
      <a href="#L33">33</a>
    </th>
    <td class="line-code">
      <pre>  report.list <span class="keyword">do</span> |list|
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L34">
      <a href="#L34">34</a>
    </th>
    <td class="line-code">
      <pre>    list.add_row <span class="symbol">:count</span> =&gt; count
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L35">
      <a href="#L35">35</a>
    </th>
    <td class="line-code">
      <pre>    list.store.total_count += count
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L36">
      <a href="#L36">36</a>
    </th>
    <td class="line-code">
      <pre>  <span class="keyword">end</span>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L37">
      <a href="#L37">37</a>
    </th>
    <td class="line-code">
      <pre><span class="keyword">end</span>  
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L38">
      <a href="#L38">38</a>
    </th>
    <td class="line-code">
      <pre>
</pre>
    </td>
  </tr>
  <tr>
    <th class="line-num" id="L39">
      <a href="#L39">39</a>
    </th>
    <td class="line-code">
      <pre>report.generate_file <span class="string"><span class="delimiter">'</span><span class="content">list.pdf</span><span class="delimiter">'</span></span>
</pre>
    </td>
  </tr>
</tbody>
</table>
</div>




        
        <div style="clear:both;"></div>
    </div>
</div>

<div id="ajax-indicator" style="display:none;"><span>ロード中...</span></div>
<div id="mosc-bottom-contents">
    <div id="mosc-bottom-menus">
        <ul><li><a href="/news" class="news">ニュース</a></li>
<li><a href="/projects" class="projects">プロジェクト</a></li>
<li><a href="/projects/mosc/wiki/Contact" class="mosc-contact">お問合わせ</a></li>
<li><a href="/account/register" class="mosc-join">今すぐ登録</a></li>
<li><a href="/projects/mosc/wiki/About" class="mosc-about">About</a></li></ul>    </div>
    <div style="clear:both;height:0;margin:0;padding:0;visibility:hidden;"></div>
</div>

<div id="footer">
  <div class="bgl"><div class="bgr">
      Powered by <a href="http://www.redmine.org/">Redmine</a> &copy; 2006-2012 Jean-Philippe Lang
  </div></div>
</div>
</div>
</div>

</body>
</html>
