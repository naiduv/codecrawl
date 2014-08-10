<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>
  File: file
  
    &mdash; Documentation for stockboy (0.9.0)
  
</title>

  <link rel="stylesheet" href="/css/style.css" type="text/css" charset="utf-8" />

  <link rel="stylesheet" href="/css/common.css" type="text/css" charset="utf-8" />

  <link rel="stylesheet" href="/css/custom.css" type="text/css" charset="utf-8" />

<script type="text/javascript" charset="utf-8">
  hasFrames = window.top.frames.main ? true : false;
  relpath = '/';
  docsPrefix = 'gems/stockboy';
  listPrefix = 'list/gems/stockboy';
  searchPrefix = 'search/gems/stockboy';
  framesUrl = '/gems/stockboy/frames/file/lib/stockboy/providers/file.rb';
</script>


  <script type="text/javascript" charset="utf-8" src="/js/jquery.js"></script>

  <script type="text/javascript" charset="utf-8" src="/js/app.js"></script>

  <script type="text/javascript" charset="utf-8" src="/js/autocomplete.js"></script>

  <script type="text/javascript" charset="utf-8" src="/js/rubydoc_custom.js"></script>


  </head>
  <body>
    <div id="header">
      <form class="search" method="get" action="/search/gems/stockboy">
  Search: <input name="q" type="search" placeholder="Search" id="search_box" size="30" value="" />
</form>
<script type="text/javascript" charset="utf-8">
  $(function() {
    $('#search_box').autocomplete($('#search_box').parent().attr('action'), {
      width: document.body.className == 'frames' ? 250 : 340,
      formatItem: function(item) {
        var values = item[0].split(",");
        return values[0] + (values[1] == '' ? "" : " <small>(" + values[1] + ")</small>");
      }
    }).result(function(event, item) {
      var values = item[0].split(",")
      $('#search_box').val(values[1]);
      location.href = values[3];
      return false;
    });
  });
</script>
<style>
  .frames form.search { position: absolute; right: 14px; top: -6px; padding-top: 10px; }
  .frames #menu .noframes { float: none; }
  .frames #menu { float: left; }
  .frames #content h1 { margin-top: 15px; }
</style>

<div id="menu">
  
    <a href="/gems" target="_top">Libraries</a> &raquo;
    <span class="title">stockboy <small>(0.9.0)</small></span>
  
  
    &raquo; 
    <a href="/gems/stockboy/index">Index</a> &raquo; 
    <span class='title'>File: file</span>
  

  <div class="noframes"><span class="title">(</span><a href="." target="_top">no frames</a><span class="title">)</span></div>
</div>


      <div id="search">
  
    <a class="full_list_link" id="class_list_link"
        href="/list/gems/stockboy/class">
      Class List
    </a>
  
    <a class="full_list_link" id="method_list_link"
        href="/list/gems/stockboy/method">
      Method List
    </a>
  
    <a class="full_list_link" id="file_list_link"
        href="/list/gems/stockboy/file">
      File List
    </a>
  
</div>
      <div class="clear"></div>
    </div>

    <iframe id="search_frame"></iframe>

    <div id="content"><div id='filecontents'><pre class="code ruby"><span class='id identifier rubyid_require'>require</span> <span class='tstring'><span class='tstring_beg'>&#39;</span><span class='tstring_content'>stockboy/provider</span><span class='tstring_end'>&#39;</span></span>

<span class='kw'>module</span> <span class='const'>Stockboy</span><span class='op'>::</span><span class='const'>Providers</span>

  <span class='comment'># Get data from a local file
</span>  <span class='comment'>#
</span>  <span class='comment'># Allows for selecting the appropriate file to be read from the given
</span>  <span class='comment'># directory by glob pattern or regex pattern. By default the +:last+ file in
</span>  <span class='comment'># the list is used, but can be controlled by sorting and reducing with the
</span>  <span class='comment'># {#pick} option.
</span>  <span class='comment'>#
</span>  <span class='comment'># == Job template DSL
</span>  <span class='comment'>#
</span>  <span class='comment'>#   provider :file do
</span>  <span class='comment'>#     file_dir &#39;/data&#39;
</span>  <span class='comment'>#     file_name /report-[0-9]+\.csv/
</span>  <span class='comment'>#     pick -&gt;(list) { list[-2] }
</span>  <span class='comment'>#   end
</span>  <span class='comment'>#
</span>  <span class='kw'>class</span> <span class='const'>File</span> <span class='op'>&lt;</span> <span class='const'>Stockboy</span><span class='op'>::</span><span class='const'>Provider</span>

    <span class='comment'># @!group Options
</span>
    <span class='comment'># @macro provider.file_options
</span>    <span class='id identifier rubyid_dsl_attr'>dsl_attr</span> <span class='symbol'>:file_name</span>
    <span class='id identifier rubyid_dsl_attr'>dsl_attr</span> <span class='symbol'>:file_dir</span>
    <span class='id identifier rubyid_dsl_attr'>dsl_attr</span> <span class='symbol'>:file_newer</span><span class='comma'>,</span> <span class='label'>alias:</span> <span class='symbol'>:since</span>

    <span class='comment'># @macro provider.file_size_options
</span>    <span class='id identifier rubyid_dsl_attr'>dsl_attr</span> <span class='symbol'>:file_smaller</span>
    <span class='id identifier rubyid_dsl_attr'>dsl_attr</span> <span class='symbol'>:file_larger</span>

    <span class='comment'># @macro provider.pick_option
</span>    <span class='id identifier rubyid_dsl_attr'>dsl_attr</span> <span class='symbol'>:pick</span>

    <span class='comment'># @!endgroup
</span>
    <span class='comment'># Initialize a File provider
</span>    <span class='comment'>#
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_initialize'>initialize</span><span class='lparen'>(</span><span class='id identifier rubyid_opts'>opts</span><span class='op'>=</span><span class='lbrace'>{</span><span class='rbrace'>}</span><span class='comma'>,</span> <span class='op'>&amp;</span><span class='id identifier rubyid_block'>block</span><span class='rparen'>)</span>
      <span class='kw'>super</span><span class='lparen'>(</span><span class='id identifier rubyid_opts'>opts</span><span class='comma'>,</span> <span class='op'>&amp;</span><span class='id identifier rubyid_block'>block</span><span class='rparen'>)</span>
      <span class='ivar'>@file_dir</span>     <span class='op'>=</span> <span class='id identifier rubyid_opts'>opts</span><span class='lbracket'>[</span><span class='symbol'>:file_dir</span><span class='rbracket'>]</span>
      <span class='ivar'>@file_name</span>    <span class='op'>=</span> <span class='id identifier rubyid_opts'>opts</span><span class='lbracket'>[</span><span class='symbol'>:file_name</span><span class='rbracket'>]</span>
      <span class='ivar'>@file_newer</span>   <span class='op'>=</span> <span class='id identifier rubyid_opts'>opts</span><span class='lbracket'>[</span><span class='symbol'>:file_newer</span><span class='rbracket'>]</span>
      <span class='ivar'>@file_smaller</span> <span class='op'>=</span> <span class='id identifier rubyid_opts'>opts</span><span class='lbracket'>[</span><span class='symbol'>:file_smaller</span><span class='rbracket'>]</span>
      <span class='ivar'>@file_larger</span>  <span class='op'>=</span> <span class='id identifier rubyid_opts'>opts</span><span class='lbracket'>[</span><span class='symbol'>:file_larger</span><span class='rbracket'>]</span>
      <span class='ivar'>@pick</span>         <span class='op'>=</span> <span class='id identifier rubyid_opts'>opts</span><span class='lbracket'>[</span><span class='symbol'>:pick</span><span class='rbracket'>]</span> <span class='op'>||</span> <span class='symbol'>:last</span>
      <span class='const'>DSL</span><span class='period'>.</span><span class='id identifier rubyid_new'>new</span><span class='lparen'>(</span><span class='kw'>self</span><span class='rparen'>)</span><span class='period'>.</span><span class='id identifier rubyid_instance_eval'>instance_eval</span><span class='lparen'>(</span><span class='op'>&amp;</span><span class='id identifier rubyid_block'>block</span><span class='rparen'>)</span> <span class='kw'>if</span> <span class='id identifier rubyid_block_given?'>block_given?</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_delete_data'>delete_data</span>
      <span class='id identifier rubyid_raise'>raise</span> <span class='const'>Stockboy</span><span class='op'>::</span><span class='const'>OutOfSequence</span><span class='comma'>,</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>must confirm #matching_file or calling #data</span><span class='tstring_end'>&quot;</span></span> <span class='kw'>unless</span> <span class='id identifier rubyid_picked_matching_file?'>picked_matching_file?</span>

      <span class='id identifier rubyid_logger'>logger</span><span class='period'>.</span><span class='id identifier rubyid_info'>info</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>Deleting file </span><span class='embexpr_beg'>#{</span><span class='id identifier rubyid_file_dir'>file_dir</span><span class='embexpr_end'>}</span><span class='tstring_content'>/</span><span class='embexpr_beg'>#{</span><span class='id identifier rubyid_matching_file'>matching_file</span><span class='embexpr_end'>}</span><span class='tstring_end'>&quot;</span></span>
      <span class='op'>::</span><span class='const'>File</span><span class='period'>.</span><span class='id identifier rubyid_delete'>delete</span> <span class='id identifier rubyid_matching_file'>matching_file</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_matching_file'>matching_file</span>
      <span class='ivar'>@matching_file</span> <span class='op'>||=</span> <span class='id identifier rubyid_pick_from'>pick_from</span><span class='lparen'>(</span><span class='id identifier rubyid_file_list'>file_list</span><span class='period'>.</span><span class='id identifier rubyid_sort'>sort</span><span class='rparen'>)</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_clear'>clear</span>
      <span class='kw'>super</span>
      <span class='ivar'>@matching_file</span> <span class='op'>=</span> <span class='kw'>nil</span>
      <span class='ivar'>@data_size</span> <span class='op'>=</span> <span class='kw'>nil</span>
      <span class='ivar'>@data_time</span> <span class='op'>=</span> <span class='kw'>nil</span>
    <span class='kw'>end</span>

    <span class='id identifier rubyid_private'>private</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_fetch_data'>fetch_data</span>
      <span class='id identifier rubyid_errors'>errors</span> <span class='op'>&lt;&lt;</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>file </span><span class='embexpr_beg'>#{</span><span class='id identifier rubyid_file_name'>file_name</span><span class='embexpr_end'>}</span><span class='tstring_content'> not found</span><span class='tstring_end'>&quot;</span></span> <span class='kw'>unless</span> <span class='id identifier rubyid_matching_file'>matching_file</span>
      <span class='id identifier rubyid_data_file'>data_file</span> <span class='op'>=</span> <span class='op'>::</span><span class='const'>File</span><span class='period'>.</span><span class='id identifier rubyid_new'>new</span><span class='lparen'>(</span><span class='id identifier rubyid_matching_file'>matching_file</span><span class='comma'>,</span> <span class='tstring'><span class='tstring_beg'>&#39;</span><span class='tstring_content'>r</span><span class='tstring_end'>&#39;</span></span><span class='rparen'>)</span> <span class='kw'>if</span> <span class='id identifier rubyid_matching_file'>matching_file</span>
      <span class='id identifier rubyid_validate_file'>validate_file</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
      <span class='ivar'>@data</span> <span class='op'>=</span> <span class='id identifier rubyid_data_file'>data_file</span><span class='period'>.</span><span class='id identifier rubyid_read'>read</span> <span class='kw'>if</span> <span class='id identifier rubyid_valid?'>valid?</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_validate'>validate</span>
      <span class='id identifier rubyid_errors'>errors</span> <span class='op'>&lt;&lt;</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>file_dir must be specified</span><span class='tstring_end'>&quot;</span></span> <span class='kw'>if</span> <span class='id identifier rubyid_file_dir'>file_dir</span><span class='period'>.</span><span class='id identifier rubyid_blank?'>blank?</span>
      <span class='id identifier rubyid_errors'>errors</span> <span class='op'>&lt;&lt;</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>file_name must be specified</span><span class='tstring_end'>&quot;</span></span> <span class='kw'>if</span> <span class='id identifier rubyid_file_name'>file_name</span><span class='period'>.</span><span class='id identifier rubyid_blank?'>blank?</span>
      <span class='id identifier rubyid_errors'>errors</span><span class='period'>.</span><span class='id identifier rubyid_empty?'>empty?</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_picked_matching_file?'>picked_matching_file?</span>
      <span class='op'>!</span><span class='op'>!</span><span class='ivar'>@matching_file</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_file_list'>file_list</span>
      <span class='kw'>case</span> <span class='id identifier rubyid_file_name'>file_name</span>
      <span class='kw'>when</span> <span class='const'>Regexp</span>
        <span class='const'>Dir</span><span class='period'>.</span><span class='id identifier rubyid_entries'>entries</span><span class='lparen'>(</span><span class='id identifier rubyid_file_dir'>file_dir</span><span class='rparen'>)</span><span class='period'>
</span><span class='id identifier rubyid_           .select'>           .select</span> <span class='lbrace'>{</span> <span class='op'>|</span><span class='id identifier rubyid_i'>i</span><span class='op'>|</span> <span class='id identifier rubyid_i'>i</span> <span class='op'>=~</span> <span class='id identifier rubyid_file_name'>file_name</span> <span class='rbrace'>}</span><span class='period'>
</span><span class='id identifier rubyid_           .map'>           .map</span>    <span class='lbrace'>{</span> <span class='op'>|</span><span class='id identifier rubyid_i'>i</span><span class='op'>|</span> <span class='id identifier rubyid_full_path'>full_path</span><span class='lparen'>(</span><span class='id identifier rubyid_i'>i</span><span class='rparen'>)</span> <span class='rbrace'>}</span>
      <span class='kw'>when</span> <span class='const'>String</span>
        <span class='const'>Dir</span><span class='lbracket'>[</span><span class='id identifier rubyid_full_path'>full_path</span><span class='lparen'>(</span><span class='id identifier rubyid_file_name'>file_name</span><span class='rparen'>)</span><span class='rbracket'>]</span>
      <span class='kw'>end</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_full_path'>full_path</span><span class='lparen'>(</span><span class='id identifier rubyid_file_name'>file_name</span><span class='rparen'>)</span>
      <span class='op'>::</span><span class='const'>File</span><span class='period'>.</span><span class='id identifier rubyid_join'>join</span><span class='lparen'>(</span><span class='id identifier rubyid_file_dir'>file_dir</span><span class='comma'>,</span> <span class='id identifier rubyid_file_name'>file_name</span><span class='rparen'>)</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_validate_file'>validate_file</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
      <span class='kw'>return</span> <span class='id identifier rubyid_errors'>errors</span> <span class='op'>&lt;&lt;</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>no matching files</span><span class='tstring_end'>&quot;</span></span> <span class='kw'>unless</span> <span class='id identifier rubyid_data_file'>data_file</span>
      <span class='id identifier rubyid_validate_file_newer'>validate_file_newer</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
      <span class='id identifier rubyid_validate_file_smaller'>validate_file_smaller</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
      <span class='id identifier rubyid_validate_file_larger'>validate_file_larger</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_validate_file_newer'>validate_file_newer</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
      <span class='id identifier rubyid_read_data_time'>read_data_time</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
      <span class='kw'>if</span> <span class='id identifier rubyid_file_newer'>file_newer</span> <span class='op'>&amp;&amp;</span> <span class='id identifier rubyid_data_time'>data_time</span> <span class='op'>&lt;</span> <span class='id identifier rubyid_file_newer'>file_newer</span>
        <span class='id identifier rubyid_errors'>errors</span> <span class='op'>&lt;&lt;</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>no new files since </span><span class='embexpr_beg'>#{</span><span class='id identifier rubyid_file_newer'>file_newer</span><span class='embexpr_end'>}</span><span class='tstring_end'>&quot;</span></span>
      <span class='kw'>end</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_validate_file_smaller'>validate_file_smaller</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
      <span class='id identifier rubyid_read_data_size'>read_data_size</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
      <span class='kw'>if</span> <span class='id identifier rubyid_file_smaller'>file_smaller</span> <span class='op'>&amp;&amp;</span> <span class='id identifier rubyid_data_size'>data_size</span> <span class='op'>&gt;</span> <span class='id identifier rubyid_file_smaller'>file_smaller</span>
        <span class='id identifier rubyid_errors'>errors</span> <span class='op'>&lt;&lt;</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>file size larger than </span><span class='embexpr_beg'>#{</span><span class='id identifier rubyid_file_smaller'>file_smaller</span><span class='embexpr_end'>}</span><span class='tstring_end'>&quot;</span></span>
      <span class='kw'>end</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_validate_file_larger'>validate_file_larger</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
      <span class='id identifier rubyid_read_data_size'>read_data_size</span><span class='lparen'>(</span><span class='id identifier rubyid_data_file'>data_file</span><span class='rparen'>)</span>
      <span class='kw'>if</span> <span class='id identifier rubyid_file_larger'>file_larger</span> <span class='op'>&amp;&amp;</span> <span class='id identifier rubyid_data_size'>data_size</span> <span class='op'>&lt;</span> <span class='id identifier rubyid_file_larger'>file_larger</span>
        <span class='id identifier rubyid_errors'>errors</span> <span class='op'>&lt;&lt;</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>file size smaller than </span><span class='embexpr_beg'>#{</span><span class='id identifier rubyid_file_larger'>file_larger</span><span class='embexpr_end'>}</span><span class='tstring_end'>&quot;</span></span>
      <span class='kw'>end</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_read_data_size'>read_data_size</span><span class='lparen'>(</span><span class='id identifier rubyid_file'>file</span><span class='rparen'>)</span>
      <span class='ivar'>@data_size</span> <span class='op'>||=</span> <span class='id identifier rubyid_file'>file</span><span class='period'>.</span><span class='id identifier rubyid_size'>size</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_read_data_time'>read_data_time</span><span class='lparen'>(</span><span class='id identifier rubyid_file'>file</span><span class='rparen'>)</span>
      <span class='ivar'>@data_time</span> <span class='op'>||=</span> <span class='id identifier rubyid_file'>file</span><span class='period'>.</span><span class='id identifier rubyid_mtime'>mtime</span>
    <span class='kw'>end</span>

  <span class='kw'>end</span>
<span class='kw'>end</span></pre></div></div>

    <div id="footer">
  Generated on Thu Jul 10 22:49:26 2014 by
  <a href="http://yardoc.org" title="Yay! A Ruby Documentation Tool" target="_parent">yard</a>
  0.8.7.4 (ruby-2.1.1).
</div>


  <script src="http://static.getclicky.com/js" type="text/javascript"></script>
  <script type="text/javascript">clicky.init(246206);</script>
  <noscript><p><img alt="Clicky" width="1" height="1" src="http://static.getclicky.com/246206ns.gif" /></p></noscript>



  <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-7172246-5', 'auto');
  ga('send', 'pageview');
  </script>


  </body>
</html>