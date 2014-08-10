<!DOCTYPE html>
<html lang='en'>
<head>
<meta charset='utf-8'>
<title>
Marius / bitcoin-ruby | 
GitLab
</title>
<link href="/assets/favicon-220424ba6cb497309f8faf8545eb5408.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
<link href="/assets/application-897f0cf2f0eae96fbe1162dd7e53f5f1.css" media="screen" rel="stylesheet" />
<script src="/assets/application-9fc13fcf7c6d49d3ae20fa29a30b85f7.js"></script>
<meta content="authenticity_token" name="csrf-param" />
<meta content="HP4lY5hvQDhEcuW7jk7VRVaQpz2NWsPWesZkpRXZjlU=" name="csrf-token" />
<script type="text/javascript">
//<![CDATA[
window.gon={};gon.default_issues_tracker="gitlab";gon.api_version="v3";gon.gravatar_url="http://www.gravatar.com/avatar/%{hash}?s=%{size}\u0026d=mm";gon.relative_url_root="";gon.gravatar_enabled=true;
//]]>
</script>
<meta name="viewport" content="width=device-width, initial-scale=1.0">




</head>

<body class='ui_mars application' data-page='projects:blob:show'>

<header class='navbar navbar-static-top navbar-gitlab'>
<div class='navbar-inner'>
<div class='container'>
<div class='app_logo'>
<span class='separator'></span>
<a class="home" href="/public"><h1>GITLAB</h1>
</a><span class='separator'></span>
</div>
<h1 class='title'><span><a href="/u/mhanne">Marius</a> / bitcoin-ruby</span></h1>
<div class='pull-right'>
<a class="btn btn-sign-in btn-new" href="/users/sign_in">Sign in</a>
</div>
<ul class='nav navbar-nav'>
<li>
<a>
<div class='hide turbolink-spinner'>
<i class='icon-refresh icon-spin'></i>
</div>
</a>
</li>
</ul>
</div>
</div>
</header>

<nav class='main-nav'>
<div class='container'><ul>
<li class="home"><a href="/mhanne/bitcoin-ruby" title="Project"><i class='icon-home'></i>
</a></li><li class="active"><a href="/mhanne/bitcoin-ruby/tree/altchains">Files</a>
</li><li class=""><a href="/mhanne/bitcoin-ruby/commits/altchains">Commits</a>
</li><li class=""><a href="/mhanne/bitcoin-ruby/network/altchains">Network</a>
</li><li class=""><a href="/mhanne/bitcoin-ruby/graphs/altchains">Graphs</a>
</li><li class=""><a href="/mhanne/bitcoin-ruby/issues">Issues
<span class='count issue_counter'>0</span>
</a></li><li class=""><a href="/mhanne/bitcoin-ruby/merge_requests">Merge Requests
<span class='count merge_counter'>0</span>
</a></li><li class=""><a href="/mhanne/bitcoin-ruby/wikis/home">Wiki</a>
</li><li class=""><a href="/mhanne/bitcoin-ruby/wall">Wall</a>
</li></ul>
</div>
</nav>
<div class='container'>
<div class='content'><div class='tree-ref-holder'>
<form accept-charset="UTF-8" action="/mhanne/bitcoin-ruby/refs/switch" class="project-refs-form" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div>
<select class="project-refs-select select2 select2-sm" id="ref" name="ref"><optgroup label="Branches"><option selected="selected" value="altchains">altchains</option>
<option value="benchmark">benchmark</option>
<option value="bip31">bip31</option>
<option value="bip33">bip33</option>
<option value="bloom_filters">bloom_filters</option>
<option value="check_spent_in_current_block">check_spent_in_current_block</option>
<option value="checkmultisig">checkmultisig</option>
<option value="cleanup_command_api">cleanup_command_api</option>
<option value="config">config</option>
<option value="default_to_compressed_pubkeys">default_to_compressed_pubkeys</option>
<option value="electrum">electrum</option>
<option value="electrum_server">electrum_server</option>
<option value="fake_chain">fake_chain</option>
<option value="fix_stuck_blockchain">fix_stuck_blockchain</option>
<option value="gh-pages">gh-pages</option>
<option value="gui">gui</option>
<option value="master">master</option>
<option value="namecoin">namecoin</option>
<option value="op_eval">op_eval</option>
<option value="p2sh">p2sh</option>
<option value="profile">profile</option>
<option value="ruby-2.0.0">ruby-2.0.0</option>
<option value="script_definitions">script_definitions</option>
<option value="spv">spv</option>
<option value="tx_validator">tx_validator</option>
<option value="utxo_namecoin">utxo_namecoin</option>
<option value="utxo_storage">utxo_storage</option>
<option value="wallet">wallet</option></optgroup><optgroup label="Tags"></optgroup></select>
<input id="destination" name="destination" type="hidden" value="blob" />
<input id="path" name="path" type="hidden" value="examples/generate_tx.rb" />
</form>


</div>
<div class='tree-holder' id='tree-holder'>
<ul class='breadcrumb'>
<li>
<i class='icon-angle-right'></i>
<a href="/mhanne/bitcoin-ruby/tree/altchains">bitcoin-ruby
</a></li>
<li>
<a href="/mhanne/bitcoin-ruby/tree/altchains/examples">examples</a>
</li>
<li>
<a href="/mhanne/bitcoin-ruby/blob/altchains/examples/generate_tx.rb"><span class='cblue'>
generate_tx.rb
</span>
</a></li>
</ul>
<ul class='blob-commit-info bs-callout bs-callout-info'>
<li class='commit js-toggle-container'>
<div class='commit-row-title'>
<a class="commit_short_id" href="/mhanne/bitcoin-ruby/commit/0bf138cb0f44ba4ce73a4da8768935a9ccf58947">0bf138cb0</a>
&nbsp;
<span class='str-truncated'>
<a class="commit-row-message" href="/mhanne/bitcoin-ruby/commit/0bf138cb0f44ba4ce73a4da8768935a9ccf58947">fix hex payload endianness in generate_tx.rb example</a>
</span>
<a class="pull-right" href="/mhanne/bitcoin-ruby/tree/0bf138cb0f44ba4ce73a4da8768935a9ccf58947">Browse Code »</a>
<div class='notes_count'>
</div>
</div>
<div class='commit-row-info'>
<a class="commit-author-link has_tooltip" data-original-title="meta.rb@gmail.com" href="mailto:meta.rb@gmail.com"><img alt="" class="avatar s16" src="http://www.gravatar.com/avatar/c96cb406b60c4b676075af0f087a76be?s=16&amp;d=mm" width="16" /> <span class="commit-author-name">Julian Langschaedel</span></a>
<div class='committed_ago'>
<time class='time_ago' data-placement='top' data-toggle='tooltip' datetime='2013-05-13T23:17:55Z' title='May 14, 2013 1:17am'>2013-05-14 01:17:55 +0200</time>
<script>$('.time_ago').timeago().tooltip()</script>
 &nbsp;
</div>
</div>
</li>

</ul>
<div class='tree-content-holder' id='tree-content-holder'>
<div class='file-holder'>
<div class='file-title'>
<i class='icon-file'></i>
<span class='file_name'>
generate_tx.rb
<small>1.48 KB</small>
</span>
<span class='options'><div class='btn-group tree-btn-group'>
<span class='btn btn-small disabled'>edit</span>
<a class="btn btn-small" href="/mhanne/bitcoin-ruby/raw/altchains/examples/generate_tx.rb" target="_blank">raw</a>
<a class="btn btn-small" href="/mhanne/bitcoin-ruby/blame/altchains/examples/generate_tx.rb">blame</a>
<a class="btn btn-small" href="/mhanne/bitcoin-ruby/commits/altchains/examples/generate_tx.rb">history</a>
</div>
</span>
</div>
<div class='file-content code'>
<div class='highlighted-data white'>
<div class='line-numbers'>
<a href="#L1" id="L1" rel="#L1"><i class='icon-link'></i>
1
</a><a href="#L2" id="L2" rel="#L2"><i class='icon-link'></i>
2
</a><a href="#L3" id="L3" rel="#L3"><i class='icon-link'></i>
3
</a><a href="#L4" id="L4" rel="#L4"><i class='icon-link'></i>
4
</a><a href="#L5" id="L5" rel="#L5"><i class='icon-link'></i>
5
</a><a href="#L6" id="L6" rel="#L6"><i class='icon-link'></i>
6
</a><a href="#L7" id="L7" rel="#L7"><i class='icon-link'></i>
7
</a><a href="#L8" id="L8" rel="#L8"><i class='icon-link'></i>
8
</a><a href="#L9" id="L9" rel="#L9"><i class='icon-link'></i>
9
</a><a href="#L10" id="L10" rel="#L10"><i class='icon-link'></i>
10
</a><a href="#L11" id="L11" rel="#L11"><i class='icon-link'></i>
11
</a><a href="#L12" id="L12" rel="#L12"><i class='icon-link'></i>
12
</a><a href="#L13" id="L13" rel="#L13"><i class='icon-link'></i>
13
</a><a href="#L14" id="L14" rel="#L14"><i class='icon-link'></i>
14
</a><a href="#L15" id="L15" rel="#L15"><i class='icon-link'></i>
15
</a><a href="#L16" id="L16" rel="#L16"><i class='icon-link'></i>
16
</a><a href="#L17" id="L17" rel="#L17"><i class='icon-link'></i>
17
</a><a href="#L18" id="L18" rel="#L18"><i class='icon-link'></i>
18
</a><a href="#L19" id="L19" rel="#L19"><i class='icon-link'></i>
19
</a><a href="#L20" id="L20" rel="#L20"><i class='icon-link'></i>
20
</a><a href="#L21" id="L21" rel="#L21"><i class='icon-link'></i>
21
</a><a href="#L22" id="L22" rel="#L22"><i class='icon-link'></i>
22
</a><a href="#L23" id="L23" rel="#L23"><i class='icon-link'></i>
23
</a><a href="#L24" id="L24" rel="#L24"><i class='icon-link'></i>
24
</a><a href="#L25" id="L25" rel="#L25"><i class='icon-link'></i>
25
</a><a href="#L26" id="L26" rel="#L26"><i class='icon-link'></i>
26
</a><a href="#L27" id="L27" rel="#L27"><i class='icon-link'></i>
27
</a><a href="#L28" id="L28" rel="#L28"><i class='icon-link'></i>
28
</a><a href="#L29" id="L29" rel="#L29"><i class='icon-link'></i>
29
</a><a href="#L30" id="L30" rel="#L30"><i class='icon-link'></i>
30
</a><a href="#L31" id="L31" rel="#L31"><i class='icon-link'></i>
31
</a><a href="#L32" id="L32" rel="#L32"><i class='icon-link'></i>
32
</a></div>
<div class='highlight'>
<pre><code>$:.unshift( File.expand_path(&quot;../../lib&quot;, __FILE__) )
require 'bitcoin'

# p Bitcoin.generate_address # returns address, privkey, pubkey, hash160

prev_tx = Bitcoin::Protocol::Tx.from_json_file('baedb362adba39753a7d2c58fd3dc4897a1b479859f707a819f096696f3facad.json') # &lt;- redeeming transaction input fetchted by for example simple_network_monitor_and_util.rb
prev_tx_output_index = 0
value = prev_tx.outputs[prev_tx_output_index].value
#value = 1337 # maybe change the value (eg subtract for fees)


tx = Bitcoin::Protocol::Tx.new
tx.add_in Bitcoin::Protocol::TxIn.new(prev_tx.binary_hash, prev_tx_output_index, 0)

tx.add_out Bitcoin::Protocol::TxOut.value_to_address(value, &quot;13qSwBXayVcJYATJ49b5uHQGwE9rQiBHqK&quot;) # &lt;- dest address

# if all in and outputs are defined, start signing inputs.
key = Bitcoin.open_key(&quot;9b2f08ebc186d435ffc1d10f3627f05ce4b983b72c76b0aee4fcce99e57b0342&quot;) # &lt;- privkey
sig = Bitcoin.sign_data(key, tx.signature_hash_for_input(0, prev_tx))
tx.in[0].script_sig = Bitcoin::Script.to_signature_pubkey_script(sig, [key.public_key_hex].pack(&quot;H*&quot;))
#tx.in[0].add_signature_pubkey_script(sig, key.public_key_hex)

# finish check
tx = Bitcoin::Protocol::Tx.new( tx.to_payload )
p tx.hash
p tx.verify_input_signature(0, prev_tx) == true

puts tx.to_json # json
#puts tx.to_payload.unpack(&quot;H*&quot;)[0] # hex binary

# use this json file for example with `ruby simple_network_monitor_and_util.rb send_tx=&lt;filename&gt;` to push/send it to the network
File.open(tx.hash + &quot;.json&quot;, 'wb'){|f| f.print tx.to_json }</code></pre>
</div>
</div>

</div>

</div>
</div>

</div>
</div>
</div>
</body>
</html>
