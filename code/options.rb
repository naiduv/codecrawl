<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>
  File: options
  
    &mdash; Documentation for savon (2.3.2)
  
</title>

  <link rel="stylesheet" href="/css/style.css" type="text/css" charset="utf-8" />

  <link rel="stylesheet" href="/css/common.css" type="text/css" charset="utf-8" />

  <link rel="stylesheet" href="/css/custom.css" type="text/css" charset="utf-8" />

<script type="text/javascript" charset="utf-8">
  hasFrames = window.top.frames.main ? true : false;
  relpath = '/';
  docsPrefix = 'gems/savon/2.3.2';
  listPrefix = 'list/gems/savon/2.3.2';
  searchPrefix = 'search/gems/savon/2.3.2';
  framesUrl = '/gems/savon/2.3.2/frames/file/lib/savon/options.rb';
</script>


  <script type="text/javascript" charset="utf-8" src="/js/jquery.js"></script>

  <script type="text/javascript" charset="utf-8" src="/js/app.js"></script>

  <script type="text/javascript" charset="utf-8" src="/js/autocomplete.js"></script>

  <script type="text/javascript" charset="utf-8" src="/js/rubydoc_custom.js"></script>


  </head>
  <body>
    <div id="header">
      <form class="search" method="get" action="/search/gems/savon/2.3.2">
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
    <span class="title">savon <small>(2.3.2)</small></span>
  
  
    &raquo; 
    <a href="/gems/savon/2.3.2/index">Index</a> &raquo; 
    <span class='title'>File: options</span>
  

  <div class="noframes"><span class="title">(</span><a href="." target="_top">no frames</a><span class="title">)</span></div>
</div>


      <div id="search">
  
    <a class="full_list_link" id="class_list_link"
        href="/list/gems/savon/2.3.2/class">
      Class List
    </a>
  
    <a class="full_list_link" id="method_list_link"
        href="/list/gems/savon/2.3.2/method">
      Method List
    </a>
  
    <a class="full_list_link" id="file_list_link"
        href="/list/gems/savon/2.3.2/file">
      File List
    </a>
  
</div>
      <div class="clear"></div>
    </div>

    <iframe id="search_frame"></iframe>

    <div id="content"><div id='filecontents'><pre class="code ruby"><span class='id identifier rubyid_require'>require</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>logger</span><span class='tstring_end'>&quot;</span></span>
<span class='id identifier rubyid_require'>require</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>httpi</span><span class='tstring_end'>&quot;</span></span>

<span class='kw'>module</span> <span class='const'>Savon</span>
  <span class='kw'>class</span> <span class='const'>Options</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_initialize'>initialize</span><span class='lparen'>(</span><span class='id identifier rubyid_options'>options</span> <span class='op'>=</span> <span class='lbrace'>{</span><span class='rbrace'>}</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span> <span class='op'>=</span> <span class='lbrace'>{</span><span class='rbrace'>}</span>
      <span class='id identifier rubyid_assign'>assign</span> <span class='id identifier rubyid_options'>options</span>
    <span class='kw'>end</span>

    <span class='id identifier rubyid_attr_reader'>attr_reader</span> <span class='symbol'>:option_type</span>

    <span class='kw'>def</span> <span class='op'>[]</span><span class='lparen'>(</span><span class='id identifier rubyid_option'>option</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='id identifier rubyid_option'>option</span><span class='rbracket'>]</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='op'>[]=</span><span class='lparen'>(</span><span class='id identifier rubyid_option'>option</span><span class='comma'>,</span> <span class='id identifier rubyid_value'>value</span><span class='rparen'>)</span>
      <span class='id identifier rubyid_value'>value</span> <span class='op'>=</span> <span class='lbracket'>[</span><span class='id identifier rubyid_value'>value</span><span class='rbracket'>]</span><span class='period'>.</span><span class='id identifier rubyid_flatten'>flatten</span>
      <span class='kw'>self</span><span class='period'>.</span><span class='id identifier rubyid_send'>send</span><span class='lparen'>(</span><span class='id identifier rubyid_option'>option</span><span class='comma'>,</span> <span class='op'>*</span><span class='id identifier rubyid_value'>value</span><span class='rparen'>)</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_include?'>include?</span><span class='lparen'>(</span><span class='id identifier rubyid_option'>option</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='period'>.</span><span class='id identifier rubyid_key?'>key?</span> <span class='id identifier rubyid_option'>option</span>
    <span class='kw'>end</span>

    <span class='id identifier rubyid_private'>private</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_assign'>assign</span><span class='lparen'>(</span><span class='id identifier rubyid_options'>options</span><span class='rparen'>)</span>
      <span class='id identifier rubyid_options'>options</span><span class='period'>.</span><span class='id identifier rubyid_each'>each</span> <span class='kw'>do</span> <span class='op'>|</span><span class='id identifier rubyid_option'>option</span><span class='comma'>,</span> <span class='id identifier rubyid_value'>value</span><span class='op'>|</span>
        <span class='kw'>self</span><span class='period'>.</span><span class='id identifier rubyid_send'>send</span><span class='lparen'>(</span><span class='id identifier rubyid_option'>option</span><span class='comma'>,</span> <span class='id identifier rubyid_value'>value</span><span class='rparen'>)</span>
      <span class='kw'>end</span>
    <span class='kw'>end</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_method_missing'>method_missing</span><span class='lparen'>(</span><span class='id identifier rubyid_option'>option</span><span class='comma'>,</span> <span class='id identifier rubyid__'>_</span><span class='rparen'>)</span>
      <span class='id identifier rubyid_raise'>raise</span> <span class='const'>UnknownOptionError</span><span class='comma'>,</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>Unknown </span><span class='embexpr_beg'>#{</span><span class='id identifier rubyid_option_type'>option_type</span><span class='embexpr_end'>}</span><span class='tstring_content'> option: </span><span class='embexpr_beg'>#{</span><span class='id identifier rubyid_option'>option</span><span class='period'>.</span><span class='id identifier rubyid_inspect'>inspect</span><span class='embexpr_end'>}</span><span class='tstring_end'>&quot;</span></span>
    <span class='kw'>end</span>

  <span class='kw'>end</span>

  <span class='kw'>class</span> <span class='const'>GlobalOptions</span> <span class='op'>&lt;</span> <span class='const'>Options</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_initialize'>initialize</span><span class='lparen'>(</span><span class='id identifier rubyid_options'>options</span> <span class='op'>=</span> <span class='lbrace'>{</span><span class='rbrace'>}</span><span class='rparen'>)</span>
      <span class='ivar'>@option_type</span> <span class='op'>=</span> <span class='symbol'>:global</span>

      <span class='id identifier rubyid_defaults'>defaults</span> <span class='op'>=</span> <span class='lbrace'>{</span>
        <span class='symbol'>:encoding</span>                  <span class='op'>=&gt;</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>UTF-8</span><span class='tstring_end'>&quot;</span></span><span class='comma'>,</span>
        <span class='symbol'>:soap_version</span>              <span class='op'>=&gt;</span> <span class='int'>1</span><span class='comma'>,</span>
        <span class='symbol'>:namespaces</span>                <span class='op'>=&gt;</span> <span class='lbrace'>{</span><span class='rbrace'>}</span><span class='comma'>,</span>
        <span class='symbol'>:logger</span>                    <span class='op'>=&gt;</span> <span class='const'>Logger</span><span class='period'>.</span><span class='id identifier rubyid_new'>new</span><span class='lparen'>(</span><span class='gvar'>$stdout</span><span class='rparen'>)</span><span class='comma'>,</span>
        <span class='symbol'>:log</span>                       <span class='op'>=&gt;</span> <span class='kw'>true</span><span class='comma'>,</span>
        <span class='symbol'>:filters</span>                   <span class='op'>=&gt;</span> <span class='lbracket'>[</span><span class='rbracket'>]</span><span class='comma'>,</span>
        <span class='symbol'>:pretty_print_xml</span>          <span class='op'>=&gt;</span> <span class='kw'>false</span><span class='comma'>,</span>
        <span class='symbol'>:raise_errors</span>              <span class='op'>=&gt;</span> <span class='kw'>true</span><span class='comma'>,</span>
        <span class='symbol'>:strip_namespaces</span>          <span class='op'>=&gt;</span> <span class='kw'>true</span><span class='comma'>,</span>
        <span class='symbol'>:convert_response_tags_to</span>  <span class='op'>=&gt;</span> <span class='id identifier rubyid_lambda'>lambda</span> <span class='lbrace'>{</span> <span class='op'>|</span><span class='id identifier rubyid_tag'>tag</span><span class='op'>|</span> <span class='id identifier rubyid_tag'>tag</span><span class='period'>.</span><span class='id identifier rubyid_snakecase'>snakecase</span><span class='period'>.</span><span class='id identifier rubyid_to_sym'>to_sym</span><span class='rbrace'>}</span><span class='comma'>,</span>
        <span class='symbol'>:multipart</span>                 <span class='op'>=&gt;</span> <span class='kw'>false</span><span class='comma'>,</span>
      <span class='rbrace'>}</span>

      <span class='id identifier rubyid_options'>options</span> <span class='op'>=</span> <span class='id identifier rubyid_defaults'>defaults</span><span class='period'>.</span><span class='id identifier rubyid_merge'>merge</span><span class='lparen'>(</span><span class='id identifier rubyid_options'>options</span><span class='rparen'>)</span>

      <span class='comment'># this option is a shortcut on the logger which needs to be set
</span>      <span class='comment'># before it can be modified to set the option.
</span>      <span class='id identifier rubyid_delayed_level'>delayed_level</span> <span class='op'>=</span> <span class='id identifier rubyid_options'>options</span><span class='period'>.</span><span class='id identifier rubyid_delete'>delete</span><span class='lparen'>(</span><span class='symbol'>:log_level</span><span class='rparen'>)</span>

      <span class='kw'>super</span><span class='lparen'>(</span><span class='id identifier rubyid_options'>options</span><span class='rparen'>)</span>

      <span class='id identifier rubyid_log_level'>log_level</span><span class='lparen'>(</span><span class='id identifier rubyid_delayed_level'>delayed_level</span><span class='rparen'>)</span> <span class='kw'>unless</span> <span class='id identifier rubyid_delayed_level'>delayed_level</span><span class='period'>.</span><span class='id identifier rubyid_nil?'>nil?</span>
    <span class='kw'>end</span>

    <span class='comment'># Location of the local or remote WSDL document.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_wsdl'>wsdl</span><span class='lparen'>(</span><span class='id identifier rubyid_wsdl_address'>wsdl_address</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:wsdl</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_wsdl_address'>wsdl_address</span>
    <span class='kw'>end</span>

    <span class='comment'># SOAP endpoint.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_endpoint'>endpoint</span><span class='lparen'>(</span><span class='id identifier rubyid_endpoint'>endpoint</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:endpoint</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_endpoint'>endpoint</span>
    <span class='kw'>end</span>

    <span class='comment'># Target namespace.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_namespace'>namespace</span><span class='lparen'>(</span><span class='id identifier rubyid_namespace'>namespace</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:namespace</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_namespace'>namespace</span>
    <span class='kw'>end</span>

    <span class='comment'># The namespace identifer.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_namespace_identifier'>namespace_identifier</span><span class='lparen'>(</span><span class='id identifier rubyid_identifier'>identifier</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:namespace_identifier</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_identifier'>identifier</span>
    <span class='kw'>end</span>

    <span class='comment'># Namespaces for the SOAP envelope.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_namespaces'>namespaces</span><span class='lparen'>(</span><span class='id identifier rubyid_namespaces'>namespaces</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:namespaces</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_namespaces'>namespaces</span>
    <span class='kw'>end</span>

    <span class='comment'># Proxy server to use for all requests.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_proxy'>proxy</span><span class='lparen'>(</span><span class='id identifier rubyid_proxy'>proxy</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:proxy</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_proxy'>proxy</span>
    <span class='kw'>end</span>

    <span class='comment'># A Hash of HTTP headers.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_headers'>headers</span><span class='lparen'>(</span><span class='id identifier rubyid_headers'>headers</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:headers</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_headers'>headers</span>
    <span class='kw'>end</span>

    <span class='comment'># Open timeout in seconds.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_open_timeout'>open_timeout</span><span class='lparen'>(</span><span class='id identifier rubyid_open_timeout'>open_timeout</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:open_timeout</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_open_timeout'>open_timeout</span>
    <span class='kw'>end</span>

    <span class='comment'># Read timeout in seconds.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_read_timeout'>read_timeout</span><span class='lparen'>(</span><span class='id identifier rubyid_read_timeout'>read_timeout</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:read_timeout</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_read_timeout'>read_timeout</span>
    <span class='kw'>end</span>

    <span class='comment'># The encoding to use. Defaults to &quot;UTF-8&quot;.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_encoding'>encoding</span><span class='lparen'>(</span><span class='id identifier rubyid_encoding'>encoding</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:encoding</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_encoding'>encoding</span>
    <span class='kw'>end</span>

    <span class='comment'># The global SOAP header. Expected to be a Hash or responding to #to_s.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_soap_header'>soap_header</span><span class='lparen'>(</span><span class='id identifier rubyid_header'>header</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:soap_header</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_header'>header</span>
    <span class='kw'>end</span>

    <span class='comment'># Sets whether elements should be :qualified or unqualified.
</span>    <span class='comment'># If you need to use this option, please open an issue and make
</span>    <span class='comment'># sure to add your WSDL document for debugging.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_element_form_default'>element_form_default</span><span class='lparen'>(</span><span class='id identifier rubyid_element_form_default'>element_form_default</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:element_form_default</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_element_form_default'>element_form_default</span>
    <span class='kw'>end</span>

    <span class='comment'># Can be used to change the SOAP envelope namespace identifier.
</span>    <span class='comment'># If you need to use this option, please open an issue and make
</span>    <span class='comment'># sure to add your WSDL document for debugging.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_env_namespace'>env_namespace</span><span class='lparen'>(</span><span class='id identifier rubyid_env_namespace'>env_namespace</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:env_namespace</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_env_namespace'>env_namespace</span>
    <span class='kw'>end</span>

    <span class='comment'># Changes the SOAP version to 1 or 2.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_soap_version'>soap_version</span><span class='lparen'>(</span><span class='id identifier rubyid_soap_version'>soap_version</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:soap_version</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_soap_version'>soap_version</span>
    <span class='kw'>end</span>

    <span class='comment'># Whether or not to raise SOAP fault and HTTP errors.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_raise_errors'>raise_errors</span><span class='lparen'>(</span><span class='id identifier rubyid_raise_errors'>raise_errors</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:raise_errors</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_raise_errors'>raise_errors</span>
    <span class='kw'>end</span>

    <span class='comment'># Whether or not to log.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_log'>log</span><span class='lparen'>(</span><span class='id identifier rubyid_log'>log</span><span class='rparen'>)</span>
      <span class='const'>HTTPI</span><span class='period'>.</span><span class='id identifier rubyid_log'>log</span> <span class='op'>=</span> <span class='id identifier rubyid_log'>log</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:log</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_log'>log</span>
    <span class='kw'>end</span>

    <span class='comment'># The logger to use. Defaults to a Savon::Logger instance.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_logger'>logger</span><span class='lparen'>(</span><span class='id identifier rubyid_logger'>logger</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:logger</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_logger'>logger</span>
    <span class='kw'>end</span>

    <span class='comment'># Changes the Logger&#39;s log level.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_log_level'>log_level</span><span class='lparen'>(</span><span class='id identifier rubyid_level'>level</span><span class='rparen'>)</span>
      <span class='id identifier rubyid_levels'>levels</span> <span class='op'>=</span> <span class='lbrace'>{</span> <span class='symbol'>:debug</span> <span class='op'>=&gt;</span> <span class='int'>0</span><span class='comma'>,</span> <span class='symbol'>:info</span> <span class='op'>=&gt;</span> <span class='int'>1</span><span class='comma'>,</span> <span class='symbol'>:warn</span> <span class='op'>=&gt;</span> <span class='int'>2</span><span class='comma'>,</span> <span class='symbol'>:error</span> <span class='op'>=&gt;</span> <span class='int'>3</span><span class='comma'>,</span> <span class='symbol'>:fatal</span> <span class='op'>=&gt;</span> <span class='int'>4</span> <span class='rbrace'>}</span>

      <span class='kw'>unless</span> <span class='id identifier rubyid_levels'>levels</span><span class='period'>.</span><span class='id identifier rubyid_include?'>include?</span> <span class='id identifier rubyid_level'>level</span>
        <span class='id identifier rubyid_raise'>raise</span> <span class='const'>ArgumentError</span><span class='comma'>,</span> <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>Invalid log level: </span><span class='embexpr_beg'>#{</span><span class='id identifier rubyid_level'>level</span><span class='period'>.</span><span class='id identifier rubyid_inspect'>inspect</span><span class='embexpr_end'>}</span><span class='tstring_content'>\n</span><span class='tstring_end'>&quot;</span></span> \
                             <span class='tstring'><span class='tstring_beg'>&quot;</span><span class='tstring_content'>Expected one of: </span><span class='embexpr_beg'>#{</span><span class='id identifier rubyid_levels'>levels</span><span class='period'>.</span><span class='id identifier rubyid_keys'>keys</span><span class='period'>.</span><span class='id identifier rubyid_inspect'>inspect</span><span class='embexpr_end'>}</span><span class='tstring_end'>&quot;</span></span>
      <span class='kw'>end</span>

      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:logger</span><span class='rbracket'>]</span><span class='period'>.</span><span class='id identifier rubyid_level'>level</span> <span class='op'>=</span> <span class='id identifier rubyid_levels'>levels</span><span class='lbracket'>[</span><span class='id identifier rubyid_level'>level</span><span class='rbracket'>]</span>
    <span class='kw'>end</span>

    <span class='comment'># A list of XML tags to filter from logged SOAP messages.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_filters'>filters</span><span class='lparen'>(</span><span class='op'>*</span><span class='id identifier rubyid_filters'>filters</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:filters</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_filters'>filters</span><span class='period'>.</span><span class='id identifier rubyid_flatten'>flatten</span>
    <span class='kw'>end</span>

    <span class='comment'># Whether to pretty print request and response XML log messages.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_pretty_print_xml'>pretty_print_xml</span><span class='lparen'>(</span><span class='id identifier rubyid_pretty_print_xml'>pretty_print_xml</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:pretty_print_xml</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_pretty_print_xml'>pretty_print_xml</span>
    <span class='kw'>end</span>

    <span class='comment'># Specifies the SSL version to use.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_ssl_version'>ssl_version</span><span class='lparen'>(</span><span class='id identifier rubyid_version'>version</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:ssl_version</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_version'>version</span>
    <span class='kw'>end</span>

    <span class='comment'># Whether and how to to verify the connection.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_ssl_verify_mode'>ssl_verify_mode</span><span class='lparen'>(</span><span class='id identifier rubyid_verify_mode'>verify_mode</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:ssl_verify_mode</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_verify_mode'>verify_mode</span>
    <span class='kw'>end</span>

    <span class='comment'># Sets the cert key file to use.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_ssl_cert_key_file'>ssl_cert_key_file</span><span class='lparen'>(</span><span class='id identifier rubyid_file'>file</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:ssl_cert_key_file</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_file'>file</span>
    <span class='kw'>end</span>

    <span class='comment'># Sets the cert key password to use.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_ssl_cert_key_password'>ssl_cert_key_password</span><span class='lparen'>(</span><span class='id identifier rubyid_password'>password</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:ssl_cert_key_password</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_password'>password</span>
    <span class='kw'>end</span>

    <span class='comment'># Sets the cert file to use.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_ssl_cert_file'>ssl_cert_file</span><span class='lparen'>(</span><span class='id identifier rubyid_file'>file</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:ssl_cert_file</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_file'>file</span>
    <span class='kw'>end</span>

    <span class='comment'># Sets the ca cert file to use.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_ssl_ca_cert_file'>ssl_ca_cert_file</span><span class='lparen'>(</span><span class='id identifier rubyid_file'>file</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:ssl_ca_cert_file</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_file'>file</span>
    <span class='kw'>end</span>

    <span class='comment'># HTTP basic auth credentials.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_basic_auth'>basic_auth</span><span class='lparen'>(</span><span class='op'>*</span><span class='id identifier rubyid_credentials'>credentials</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:basic_auth</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_credentials'>credentials</span><span class='period'>.</span><span class='id identifier rubyid_flatten'>flatten</span>
    <span class='kw'>end</span>

    <span class='comment'># HTTP digest auth credentials.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_digest_auth'>digest_auth</span><span class='lparen'>(</span><span class='op'>*</span><span class='id identifier rubyid_credentials'>credentials</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:digest_auth</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_credentials'>credentials</span><span class='period'>.</span><span class='id identifier rubyid_flatten'>flatten</span>
    <span class='kw'>end</span>

    <span class='comment'># NTLM auth credentials.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_ntlm'>ntlm</span><span class='lparen'>(</span><span class='op'>*</span><span class='id identifier rubyid_credentials'>credentials</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:ntlm</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_credentials'>credentials</span><span class='period'>.</span><span class='id identifier rubyid_flatten'>flatten</span>
    <span class='kw'>end</span>

    <span class='comment'># WSSE auth credentials for Akami.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_wsse_auth'>wsse_auth</span><span class='lparen'>(</span><span class='op'>*</span><span class='id identifier rubyid_credentials'>credentials</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:wsse_auth</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_credentials'>credentials</span><span class='period'>.</span><span class='id identifier rubyid_flatten'>flatten</span>
    <span class='kw'>end</span>

    <span class='comment'># Instruct Akami to enable wsu:Timestamp headers.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_wsse_timestamp'>wsse_timestamp</span><span class='lparen'>(</span><span class='op'>*</span><span class='id identifier rubyid_timestamp'>timestamp</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:wsse_timestamp</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_timestamp'>timestamp</span><span class='period'>.</span><span class='id identifier rubyid_flatten'>flatten</span>
    <span class='kw'>end</span>

    <span class='comment'># Instruct Nori whether to strip namespaces from XML nodes.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_strip_namespaces'>strip_namespaces</span><span class='lparen'>(</span><span class='id identifier rubyid_strip_namespaces'>strip_namespaces</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:strip_namespaces</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_strip_namespaces'>strip_namespaces</span>
    <span class='kw'>end</span>

    <span class='comment'># Tell Gyoku how to convert Hash key Symbols to XML tags.
</span>    <span class='comment'># Accepts one of :lower_camelcase, :camelcase, :upcase, or :none.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_convert_request_keys_to'>convert_request_keys_to</span><span class='lparen'>(</span><span class='id identifier rubyid_converter'>converter</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:convert_request_keys_to</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_converter'>converter</span>
    <span class='kw'>end</span>

    <span class='comment'># Tell Nori how to convert XML tags from the SOAP response into Hash keys.
</span>    <span class='comment'># Accepts a lambda or a block which receives an XML tag and returns a Hash key.
</span>    <span class='comment'># Defaults to convert tags to snakecase Symbols.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_convert_response_tags_to'>convert_response_tags_to</span><span class='lparen'>(</span><span class='id identifier rubyid_converter'>converter</span> <span class='op'>=</span> <span class='kw'>nil</span><span class='comma'>,</span> <span class='op'>&amp;</span><span class='id identifier rubyid_block'>block</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:convert_response_tags_to</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_block'>block</span> <span class='op'>||</span> <span class='id identifier rubyid_converter'>converter</span>
    <span class='kw'>end</span>

    <span class='comment'># Instruct Savon to create a multipart response if available.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_multipart'>multipart</span><span class='lparen'>(</span><span class='id identifier rubyid_multipart'>multipart</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:multipart</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_multipart'>multipart</span>
    <span class='kw'>end</span>
  <span class='kw'>end</span>

  <span class='kw'>class</span> <span class='const'>LocalOptions</span> <span class='op'>&lt;</span> <span class='const'>Options</span>

    <span class='kw'>def</span> <span class='id identifier rubyid_initialize'>initialize</span><span class='lparen'>(</span><span class='id identifier rubyid_options'>options</span> <span class='op'>=</span> <span class='lbrace'>{</span><span class='rbrace'>}</span><span class='rparen'>)</span>
      <span class='ivar'>@option_type</span> <span class='op'>=</span> <span class='symbol'>:local</span>

      <span class='id identifier rubyid_defaults'>defaults</span> <span class='op'>=</span> <span class='lbrace'>{</span>
        <span class='symbol'>:advanced_typecasting</span> <span class='op'>=&gt;</span> <span class='kw'>true</span><span class='comma'>,</span>
        <span class='symbol'>:response_parser</span>      <span class='op'>=&gt;</span> <span class='symbol'>:nokogiri</span><span class='comma'>,</span>
        <span class='symbol'>:multipart</span>            <span class='op'>=&gt;</span> <span class='kw'>false</span>
      <span class='rbrace'>}</span>

      <span class='kw'>super</span> <span class='id identifier rubyid_defaults'>defaults</span><span class='period'>.</span><span class='id identifier rubyid_merge'>merge</span><span class='lparen'>(</span><span class='id identifier rubyid_options'>options</span><span class='rparen'>)</span>
    <span class='kw'>end</span>

    <span class='comment'># The local SOAP header. Expected to be a Hash or respond to #to_s.
</span>    <span class='comment'># Will be merged with the global SOAP header if both are Hashes.
</span>    <span class='comment'># Otherwise the local option will be prefered.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_soap_header'>soap_header</span><span class='lparen'>(</span><span class='id identifier rubyid_header'>header</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:soap_header</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_header'>header</span>
    <span class='kw'>end</span>

    <span class='comment'># The SOAP message to send. Expected to be a Hash or a String.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_message'>message</span><span class='lparen'>(</span><span class='id identifier rubyid_message'>message</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:message</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_message'>message</span>
    <span class='kw'>end</span>

    <span class='comment'># SOAP message tag (formerly known as SOAP input tag). If it&#39;s not set, Savon retrieves the name from
</span>    <span class='comment'># the WSDL document (if available). Otherwise, Gyoku converts the operation name into an XML element.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_message_tag'>message_tag</span><span class='lparen'>(</span><span class='id identifier rubyid_message_tag'>message_tag</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:message_tag</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_message_tag'>message_tag</span>
    <span class='kw'>end</span>

    <span class='comment'># Attributes for the SOAP message tag.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_attributes'>attributes</span><span class='lparen'>(</span><span class='id identifier rubyid_attributes'>attributes</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:attributes</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_attributes'>attributes</span>
    <span class='kw'>end</span>

    <span class='comment'># Value of the SOAPAction HTTP header.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_soap_action'>soap_action</span><span class='lparen'>(</span><span class='id identifier rubyid_soap_action'>soap_action</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:soap_action</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_soap_action'>soap_action</span>
    <span class='kw'>end</span>

    <span class='comment'># Cookies to be used for the next request.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_cookies'>cookies</span><span class='lparen'>(</span><span class='id identifier rubyid_cookies'>cookies</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:cookies</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_cookies'>cookies</span>
    <span class='kw'>end</span>

    <span class='comment'># The SOAP request XML to send. Expected to be a String.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_xml'>xml</span><span class='lparen'>(</span><span class='id identifier rubyid_xml'>xml</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:xml</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_xml'>xml</span>
    <span class='kw'>end</span>

    <span class='comment'># Instruct Nori to use advanced typecasting.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_advanced_typecasting'>advanced_typecasting</span><span class='lparen'>(</span><span class='id identifier rubyid_advanced'>advanced</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:advanced_typecasting</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_advanced'>advanced</span>
    <span class='kw'>end</span>

    <span class='comment'># Instruct Nori to use :rexml or :nokogiri to parse the response.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_response_parser'>response_parser</span><span class='lparen'>(</span><span class='id identifier rubyid_parser'>parser</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:response_parser</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_parser'>parser</span>
    <span class='kw'>end</span>

    <span class='comment'># Instruct Savon to create a multipart response if available.
</span>    <span class='kw'>def</span> <span class='id identifier rubyid_multipart'>multipart</span><span class='lparen'>(</span><span class='id identifier rubyid_multipart'>multipart</span><span class='rparen'>)</span>
      <span class='ivar'>@options</span><span class='lbracket'>[</span><span class='symbol'>:multipart</span><span class='rbracket'>]</span> <span class='op'>=</span> <span class='id identifier rubyid_multipart'>multipart</span>
    <span class='kw'>end</span>

  <span class='kw'>end</span>
<span class='kw'>end</span></pre></div></div>

    <div id="footer">
  Generated on Sat Jun 28 01:59:33 2014 by
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