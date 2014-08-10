<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Expires" content="Sun, 10 Aug 2014 06:55:00 GMT">
<title>File Details: /trunk/app/lib/minicmd/miniexcelinfo.rb (119) - rubyminicmd (svn) - RubyMiniCommands - SourceForge.JP</title>

<!--[if lte IE 6]>
<style type="text/css">body {behavior: url(/css/csshover.htc);}</style>
<![endif]-->
<link rel="stylesheet" type="text/css" href="http://static.sourceforge.jp/min/base-2af6240b6ba7f1422b887ca527e7d3f0.min.css">
<!--[if lte IE 6]>
<link rel="stylesheet" type="text/css" href="http://static.sourceforge.jp/css/bootstrap-ie6.css?t=1331520993">
<![endif]-->
<!--[if lte IE 7]>
<link rel="stylesheet" type="text/css" href="http://static.sourceforge.jp/css/FontAwesome/css/font-awesome-ie7.css?t=1371719534">
<![endif]-->

<link rev="MADE" href="mailto:webmaster@sourceforge.jp">
<link rel="INDEX" href="http://sourceforge.jp/">
<link rel="CONTENTS" href="http://sourceforge.jp/">
<link rel="SHORTCUT ICON" href="http://static.sourceforge.jp/favicon.ico" type="image/x-icon">
<link rel="alternate" hreflang="en" href="http://en.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb" />
<link rel="alternate" hreflang="zh" href="http://zh.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb" />
<link rel="alternate" hreflang="de" href="http://de.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb" />
<link rel="alternate" hreflang="fr" href="http://fr.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb" />
<link rel="alternate" hreflang="ko" href="http://ko.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb" />
<link rel="alternate" hreflang="es" href="http://es.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb" />
<link rel="alternate" hreflang="pt" href="http://pt.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb" />
<link rel="alternate" hreflang="x-default" href="http://sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb" />
<link rel="stylesheet" type="text/css" href="http://static.sourceforge.jp/css/wiki-compact.css?t=1365503421">
<link rel="stylesheet" type="text/css" href="http://static.sourceforge.jp/css/prettify.css?t=1335233495">
<link rel="stylesheet" type="text/css" href="http://static.sourceforge.jp/css/scmviewer.css?t=1397466091">
<link rel="stylesheet" type="text/css" href="http://static.sourceforge.jp/css/graph.css?t=1382877057">
<link rel="alternate" title="Recent Commits" type="application/rss+xml" href="/projects/rubyminicmd/scm/svn/rss">
<meta property="og:type" content="website" />
<meta property="og:title" content="File Details: /trunk/app/lib/minicmd/miniexcelinfo.rb (119) - rubyminicmd (svn) - RubyMiniComm..." />
<meta property="fb:app_id" content="224902477537179" />
<meta property="og:image" content="http://static.en.sourceforge.jp/default-photo.png" />
<meta property="twitter:card" content="summary" />
<meta property="twitter:site" content="@sourceforgejp" />
<meta property="twitter:domain" content="sourceforge.jp" />
<meta property="og:description" content="File Details: /trunk/app/lib/minicmd/miniexcelinfo.rb (119) - rubyminicmd (svn) - RubyMiniCommands #opensource #sfjp" />
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"></script>
<script type="text/javascript" src="http://static.sourceforge.jp/min/base-49dc82012a96f4113f0a2300f1c27e6d.min.js"></script>
<!--[if lt IE 9]>
<script type="text/javascript" src="http://static.sourceforge.jp/js/html5.js?t=1331520990"></script>
<![endif]-->
<!--[if lte IE 6]>
<script type="text/javascript" src="http://static.sourceforge.jp/js/IE7.js?t=1331520990IE7_PNG_SUFFIX=".png";</script>
<![endif]-->
<script type="text/javascript" src="http://static.sourceforge.jp/js/scmviewer.js?t=1335953104"></script>
<script type="text/javascript" src="http://static.sourceforge.jp/js/google-code-prettify/prettify.js?t=1335233495"></script>
<script type="text/javascript" src="http://static.sourceforge.jp/js/chamber_fork.js?t=1348041636"></script>
<script type="text/javascript" src="http://static.sourceforge.jp/js/chamber_validate.js?t=1343790999"></script>
<script type="text/javascript" src="http://static.sourceforge.jp/js/d3.min.js?t=1367494436"></script>
<script type="text/javascript" src="http://static.sourceforge.jp/js/graph.js?t=1370504760"></script>
<!-- START: additional_headers -->
<script type='text/javascript' src='//static.sourceforge.jp/js/ad_dfp_dev.js'></script>
<style>
#gpt-sf_dev_rec{min-height:250px;margin-bottom:8px;}
#docman_document{word-break:break-all;word-wrap:break-word;}
#head-ad-text{max-width:666px;overflow:hidden;}
</style><!-- END: additional_headers -->
<script type="text/javascript">var sfjp_base_url = '//en.sourceforge.jp';var sfjp_static_base_url = '//static.sourceforge.jp/';var sfjp_i18n = {"apply":"Apply","cancel":"Cancel","update":"Update","delete":"Delete","yes":"Yes","no":"No","upload":"Upload","close":"Close","send":"Send","prev":"Prev","next":"Next","rank":" ","times":"times","points":"points","counts":" ","error":"Error","validate_sfjp_email":"Can not use SF.JP email address","validate_denied_email":"You can not use the email address by technicaly reasons.","validate_required":"This field is required.","validate_minlength":"Please enter at least {0} characters.","validate_maxlength":"Please enter at no more than {0} characters.","validate_email":"Please enter a valid email address.","validate_equalto":"Please enter the same value again.","validate_skill_name":"Skill name is duplicated","validate_dup_user":"The username is already used.","validate_dup_email":"The email address is already registered","validate_repos_name":"Number,Alphabet,- and _ . only start with Number or Alphabet","validate_sfjp_project_license_other":"Please describe more details of License","validate_sfjp_projectname_syntax":"Can use only Number,Alphabet and - only, start with Number or Alphabet","validate_sfjp_projectname_unique":"This project name is already registered","to_profile":"To Profile Edit","end_of_tutorial":"Next","no_file_selected":"No files are selected","upload_is_running":"File upload is still running.","file_select":"Select File","no_releases":"No releases for this package","no_packages":""};</script><script type="text/javascript">
var _gaq = _gaq || [];
_gaq.push(["_setAccount", "UA-739864-3"]);
_gaq.push(["_trackPageview"]);
(function() {
	var ga = document.createElement("script"); ga.type = "text/javascript"; ga.async = true;
	ga.src = ("https:" == document.location.protocol ? "https://ssl" : "http://www") + ".google-analytics.com/ga.js";
	var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(ga, s);
})();
</script>
<!--
<PageMap>
  <DataObject type="page-info">
    <Attribute name="action" value="blobs"/>
    <Attribute name="reltype" value="group"/>
  </DataObject>
  <DataObject type="group-info">
    <Attribute name="unix-name" value="rubyminicmd"/>
    <Attribute name="name" value="RubyMiniCommands"/>
    <Attribute name="type" value="internal"/>
    <Attribute name="registered-at" value="1184986815"/>
    <Attribute name="lastupdate" value="1328708952"/>
    <Attribute name="image" value=""/>
  </DataObject>
</PageMap>
-->
</head><body>
<div id="message-area">
</div>
<header id="main_header">
  <div class="navbar navbar-inverse">
    <div class="navbar-inner">
      <div class="container-fluid">
	<a class="brand" href="http://en.sourceforge.jp/"><img src="http://static.sourceforge.jp/sfjp_logo_h17.png" width="202" height="17" alt="SourceForge.JP -- Develop and Download Open Source Software"></a>

	<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
	  <span class="icon-bar"></span>
	  <span class="icon-bar"></span>
	  <span class="icon-bar"></span>
	</a>
	<div class="nav-collapse">
	  <ul class="nav">
	    <li >
	      <a class="sfjp-nav-icon sfjp-nav-icon-download" href="/softwaremap/trove_list.php">Download</a>
	    </li>
	    <li >
	      <a class="sfjp-nav-icon sfjp-nav-icon-magazine" href="http://en.sourceforge.jp/magazine/">Magazine</a>
	    </li>
	    <li class="active">
	      <a class="sfjp-nav-icon sfjp-nav-icon-devel" id="main_menu_develop_link" href="/develop/">Develop</a>
	    </li>
	    <li >
	      <a class="sfjp-nav-icon sfjp-nav-icon-pastebin" id="main_menu_pastebin_link" href="/pastebin/">Pastebin</a>
	    </li>
	  </ul>
	  <ul class="nav pull-right">
  <li class="dropdown">
    <a id="account-dropdown" class="dropdown-toggle" data-toggle="dropdown" href="#">Account<b class="caret"></b></a>
    <ul class="dropdown-menu" role="menu">
      <li role="presentation" id="sfjp-login-item" data-return_to="/">
	<div role="menuitem" class="social-login-menu-wrap social-login-menu-gplus-wrap">
	  <a class="btn social-login sfjp-login" data-toggle="modal" href="#loginbox"><i class="icon-circle"></i> <span>Login</span></a>

	</div>
      </li>
      <li role="presentation">
	<a role="menuitem" data-toggle="modal" data-remote="/ajax/account/forgetpw_inner.php" data-target="#forgetpwbox" href="#forgetpwbox">Forget Account/Password</a>
      </li>
      <li role="presentation">
	<a role="menuitem" href="/account/register.php">Create Account</a>
      </li>
            <li role="presentation" class="divider"></li>
      <li role="presentation" class="dropdown-submenu">
	<a role="menuitem" tabindex="-1" href="#">Language</a>
	<ul class="dropdown-menu" role="menu">
	  <li role="presentation">
	    <a role="menuitem" href="http://sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb" rel="tips" title="Auto select display language depend on browser setting" alt="auto" data-placement="bottom">
	      <span class="spclass-float-left-nontext spimg-auto"></span>
	      Automatic	    </a>
	  </li>
	  	  	  <li role="presentation">
	    <a role="menuitem" href="http://en.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb">
	      <span class="spclass-float-left-nontext spimg-en"></span>
	      English	    </a>
	  </li>
	  	  	  	  <li role="presentation">
	    <a role="menuitem" href="http://zh.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb">
	      <span class="spclass-float-left-nontext spimg-zh"></span>
	      中文	    </a>
	  </li>
	  	  	  <li role="presentation">
	    <a role="menuitem" href="http://de.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb">
	      <span class="spclass-float-left-nontext spimg-de"></span>
	      Deutsch	    </a>
	  </li>
	  	  	  <li role="presentation">
	    <a role="menuitem" href="http://fr.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb">
	      <span class="spclass-float-left-nontext spimg-fr"></span>
	      Français	    </a>
	  </li>
	  	  	  <li role="presentation">
	    <a role="menuitem" href="http://ko.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb">
	      <span class="spclass-float-left-nontext spimg-ko"></span>
	      한국말	    </a>
	  </li>
	  	  	  <li role="presentation">
	    <a role="menuitem" href="http://es.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb">
	      <span class="spclass-float-left-nontext spimg-es"></span>
	      Español	    </a>
	  </li>
	  	  	  <li role="presentation">
	    <a role="menuitem" href="http://pt.sourceforge.jp/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb">
	      <span class="spclass-float-left-nontext spimg-pt"></span>
	      Português	    </a>
	  </li>
	  	</ul>
      </li>
          </ul>
  </li>
  <li>
    <a href="/docs/FrontPage">Help</a>
  </li>
</ul><!-- .nav.pull-right -->

<div id="loginbox" class="modal hide fade focus-on-shown">
  <div class="modal-header">
    <a class="close" data-dismiss="modal">×</a>
    <h3>Login</h3>
  </div><!-- .modal-header -->
    <form id="loginform" method="post" action="https://sourceforge.jp/account/login.php" class="form-horizontal need-validate">
      <div class="modal-body">
	<input type="hidden" name="return_to" value="/" />
	<input type="hidden" name="action" value="loginsubmit" />
	<div class="control-group">
	  <label class="control-label" for="loginform-login">Login Name</label>
	  <div class="controls">
	    <input id="loginform-login" type="text" name="form_loginname" class="required first-focus-on-shown" />
	  </div>
	  <label class="control-label" for="loginform-password">Password</label>
	  <div class="controls">
	    <input id="loginform-password" type="password" name="form_pw" class="required" />
	  </div>
	</div>
      </div><!-- .modal-body -->
      <div class="modal-footer">
	<button type="submit" class="btn btn-primary">Login</button>
	<button type="button" class="btn" data-dismiss="modal">Cancel</button>
      </div><!-- .modal-footer -->
    </form>
</div>

<div id="forgetpwbox" class="modal hide fade focus-on-shown">
  <div class="modal-header">
    <a class="close" data-dismiss="modal">×</a>
    <h3>Forget Account/Password</h3>
  </div><!-- .modal-header -->
  <form id="forgetpwform" method="post" action="/ajax/account/forgotpw.php" class="form-horizontal need-validate" data-ajax="1">
    <div class="modal-body" data-remote="/ajax/account/forgetpw_inner.php"></div><!-- .modal-body -->
    <div class="modal-footer">
      <button type="submit" class="btn btn-primary">Submit</button>
      <button type="button" class="btn" data-dismiss="modal">Cancel</button>
    </div><!-- .modal-footer -->
  </form>
</div>

<div id="login-openid-modal" class="modal hide fade focus-on-shown">
  <div class="modal-header">
    <a class="close" data-dismiss="modal">×</a>
    Log in with OpenID  </div>
  <form id="login-openid-form" method="post" action="/account/openid_login.php" class="form-horizontal openid-form">
    <input type="hidden" name="return_to" value="/" />
    <div class="modal-body" data-remote="/ajax/account/openid_login_inner.php"></div>
    <div class="modal-footer">
      <button type="button" class="btn" data-dismiss="modal">Close</button>
    </div>
  </form>
</div>
	</div><!-- .nav-collapse -->
      </div><!-- .container-fluid -->
      </div><!-- .navbar-inner -->
    </div><!-- .navbar.navbar-fixed-top -->

<div class="container-fluid">
  <div id="ad-leaderboard">
    <div id='gpt-sf_dev_728'>
<script type='text/javascript'>
googletag.cmd.push(function() { googletag.display('gpt-sf_dev_728'); });
</script>
</div>


  </div><!-- id="ad-leaderboard" -->
</div>

<!-- START: site_announce -->
<!-- *DO NOT REMOVE THIS COMMENT LINE* --><!-- END: site_annouce -->
</header><!-- #mian_header -->
<table id="frame">
<tbody>
<tr>
<td id="left-column">
    <div class="pull-right no-sidebar-common">
      <form class="form-search form-horizontal" name="searchform" action="/search/" method="get" id="searchform">
    <input type="hidden" name="ie" value="UTF-8" />
    <label for="search-type-select">Category:</label>
    <select id="search-type-select" class="span2" name="t" onChange="switch (this.options[this.selectedIndex].value) {
								     case 'soft': case 'people': case 'personalforge': document.getElementById('searchform').action='/search/'; break;
								     case 'magazine': document.getElementById('searchform').action='/magazine/search'; break;
								     case 'wiki': document.getElementById('searchform').action='/wiki/!search'; break;
								     }">
      <option value="soft">Software</option>
      <option value="people">People</option>
      <option value="personalforge">PersonalForge</option>
      <option value="magazine" >Magazine</option>
      <option value="wiki" >Wiki</option>
    </select>
    <input type="hidden" name="scope" value="all" />
    <input type="search" value="" id="searchbox" name="q" class="search-query" />
    <button type="submit" class="btn"><i class="icon-search"></i> Search</button>
  </form>
    <div class="social-buttons">
  <div id="fb-button" class="social-button-wrap">
    <div class="fb-like" data-send="false" data-layout="button_count" data-show-faces="true"></div>
  </div>
  <div id="twitter-button" class="social-button-wrap"></div>
  <div id="gplus-button" class="social-button-wrap">
    <g:plusone size="medium"></g:plusone>
  </div>
  <div class="left-clear"></div>
</div>
  </div>
  <div id="top-nav-wrap">
<div id="top-nav" class="topnav">
    <div id="breadcrumbs" itemscope itemtype="http://data-vocabulary.org/Breadcrumb">
                 <a href="/" itemprop="url"><span itemprop="title">SourceForge.JP</span></a>
         &gt;                  <a href="/softwaremap/" itemprop="url"><span itemprop="title">Find Software</span></a>
         &gt;                  <a href="/projects/rubyminicmd/" itemprop="url"><span itemprop="title">RubyMiniCommands</span></a>
         &gt;                  <a href="/projects/rubyminicmd/scm/" itemprop="url"><span itemprop="title">SCM</span></a>
         &gt;                  <a href="/projects/rubyminicmd/scm/svn/" itemprop="url"><span itemprop="title">SVN</span></a>
         &gt;         <b>        File Details        </b>      </div>
      <h1>RubyMiniCommands</h1>
  
    <ul class="nav nav-tabs content-menu-for-project">
    <li class="dropdown">
  <a href="#" class="dropdown-toggle" data-toggle="dropdown">Description<b class="caret"></b></a>
  <ul class="dropdown-menu" role="menu">
    <li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/simple/">Project Summary</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/devel/">Developer Dashboard</a></li>
<li role="presentation"><a role="menuitem" href="http://rubyminicmd.sourceforge.jp">Web Page</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/reviews/">Project Reviews</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/stats/">Statistics</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/history/">History</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/memberlist/">Developers</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/images/">Project Images</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/feeds/">Feed list</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/keywords/">Search Keywords</a></li>
  </ul>
</li>

<li role="presentation" class="dropdown">
  <a role="menuitem" href="/projects/rubyminicmd/releases/">Downloads</a>
</li>
<li role="presentation" class="active dropdown">
  <a role="menuitem" href="#" class="dropdown-toggle" data-toggle="dropdown">Source Code<b class="caret"></b></a>
  <ul class="dropdown-menu" role="menu">
    <li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/scm/">Code Repository list</a></li>
                <li class="divider"></li>
    <li role="menuitem" class="nav-header">Subversion</li>
    <li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/scm/svn/">View Repository</a></li>
                      </ul>
</li>

<li role="presentation" class="dropdown">
  <a role="menuitem" href="#" class="dropdown-toggle" data-toggle="dropdown">Ticket<b class="caret"></b></a>
  <ul class="dropdown-menu" role="menu">
    <li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/ticket/">Ticket List</a></li>
    <li role="presentation"><a role="menuitem" href="/ticket/milestonelist.php?group_id=2989">Milestones List</a></li>
    <li role="presentation"><a role="menuitem" href="/ticket/types.php?group_id=2989">Types List</a></li>
    <li role="presentation"><a role="menuitem" href="/ticket/components.php?group_id=2989">Components List</a></li>
    <li role="presentation"><a role="menuitem" href="/ticket/link_list.php?group_id=2989">Frequently use Ticket Lists/RSS</a></li>
    <li role="presentation"><a role="menuitem" href="/ticket/newticket.php?group_id=2989">Submit New Ticket</a></li>
          </ul>
</li>

<li role="presentation" class="dropdown">
  <a role="menuitem" href="#" class="dropdown-toggle" data-toggle="dropdown">Documents<b class="caret"></b></a>
  <ul class="dropdown-menu" role="menu">
    <li role="menuitem" class="nav-header">Wiki</li>
    <li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/wiki/FrontPage">show FrontPage</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/wiki/TitleIndex">Title index</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/wiki/RecentChanges">Recent changes</a></li>
    <li class="divider"></li>
    <li role="menuitem" class="nav-header">Doc Mgr</li>
        <li role="presentation" ><a role="menuitem" href="/projects/rubyminicmd/docman/">List Docs</a></li>
      </ul>
</li>

<li role="presentation" class="dropdown">
  <a role="menuitem" href="#" class="dropdown-toggle" data-toggle="dropdown">Communication<b class="caret"></b></a>
  <ul class="dropdown-menu" role="menu">
            <li role="menuitem" class="nav-header">Forum</li>
        <li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/forums/">List Forums</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/forums/12428/">Help (1)</a></li>
<li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/forums/12427/">Open Discussion (1)</a></li>
                    <li class="divider"></li>
    <li role="menuitem" class="nav-header">Mailing Lists</li>
        <li role="presentation"><a role="menuitem" href="/projects/rubyminicmd/lists/">list of ML</a></li>
          </ul>
</li>

<li role="presentation" class=""><a role="menuitem" href="/projects/rubyminicmd/news/">News</a></li>

  </ul>
  
</div><!-- #top-nav .topnav -->
</div><!-- #top-nav-wrap -->

<div id="head-ad-text-wrap">
  <div id="head-ad-text">
    <div id='gpt-sf_dev_text'>
<script type='text/javascript'>
googletag.cmd.push(function() { googletag.display('gpt-sf_dev_text'); });
</script>
</div>
  </div><!-- #head-ad-text -->
</div>
<div id="scm-wrapper">
<div class="repos-header">

<div class="repos-urls-box">
<ul class="repos-urls">
  <li class="repos-url-ro"><span class="selected" rel="http://svn.sourceforge.jp/svnroot/rubyminicmd/trunk/app/lib/minicmd/miniexcelinfo.rb">
    R/O
  </span></li>
  <li class="repos-url-rw"><span class="disabled" rel="svn+ssh://svn.sourceforge.jp/svnroot/rubyminicmd/trunk/app/lib/minicmd/miniexcelinfo.rb">
    R/W (SSH)
  </span></li>
  <li class="repos-url-rw"><span class="disabled" rel="https://svn.sourceforge.jp/svnroot/rubyminicmd/trunk/app/lib/minicmd/miniexcelinfo.rb">
    R/W (HTTPS)
  </span></li>
</ul>
<input type="text" class="repos-git-url" readonly="true" value="http://svn.sourceforge.jp/svnroot/rubyminicmd/trunk/app/lib/minicmd/miniexcelinfo.rb">
</div>

<div class="scm-navi-pills">
<ul class="nav nav-pills">
<li class="">
<a href="/projects/rubyminicmd/scm/svn/summary">Summary</a></li>
<li class="active">
<a href="/projects/rubyminicmd/scm/svn/tree/">SourceTree</a></li>
<li class="">
<a href="/projects/rubyminicmd/scm/svn/commits">Commits</a></li>
<li class="">
<a href="/projects/rubyminicmd/scm/svn/branches">
Branches</a></li>
<li class="">
<a href="/projects/rubyminicmd/scm/svn/tags">Tags</a></li>
</ul></div>

<h2 class="repos-header-title">
rubyminicmd: </h2>


</div>
<br clear="both">
<ul class="breadcrumb scm-tree-breadcrumb"><li><a href="/projects/rubyminicmd/scm/svn/tree/119/">[rubyminicmd]</a></li> <span class="divider">/</span> <li><a href="/projects/rubyminicmd/scm/svn/tree/119/trunk/">trunk</a></li> <span class="divider">/</span> <li><a href="/projects/rubyminicmd/scm/svn/tree/119/trunk/app/">app</a></li> <span class="divider">/</span> <li><a href="/projects/rubyminicmd/scm/svn/tree/119/trunk/app/lib/">lib</a></li> <span class="divider">/</span> <li><a href="/projects/rubyminicmd/scm/svn/tree/119/trunk/app/lib/minicmd/">minicmd</a></li> <span class="divider">/</span> <li class="active"><strong>miniexcelinfo.rb</strong> @ <a href="/projects/rubyminicmd/scm/svn/commits/119">r119</a></li></ul><h3 class="">File Info</h3>
<table class="table table-bordered">
<tr><th>Rev.</th>
<td><a href="/projects/rubyminicmd/scm/svn/commits/70">70</a></td>
</tr>
<tr><th>Size</th>
<td>5,608 bytes</td>
</tr>
<tr><th>Time</th>
<td>2009-09-27 09:12:05</td>
</tr>
<tr><th>Author</th>
<td><a href="/users/kurukuru-papa/" class="user-link">kurukuru-papa</a></td>
</tr>
<tr><th style="width: 20px; white-space: nowrap;">Log Message</th>
<td><div class="commit-log"><div class="wiki-compact"><p>インストーラー（setup.rb）に対応<br /></p></div></div></td>
</tr>
</table>


<h3 class="">Content</h3>
<div class="btn-group export-raw">
<a rel="nofollow" class="btn btn" href="/projects/rubyminicmd/scm/svn/blobs/119/trunk/app/lib/minicmd/miniexcelinfo.rb?export=raw">
Export as raw format</a>
</div>
<div class="blob-preview">
<pre class="syntax-highlighted syntax-highlighted-rb"><ol><li><span class="default"><a name="ln1"></a> <i><span class="brown">#! ruby -Ks</span></i></span></li><li><span class="default"><a name="ln2"></a> <i><span class="brown"># miniexcelinfo.rb</span></i></span></li><li><span class="default"><a name="ln3"></a> <i><span class="brown">#</span></i></span></li><li><span class="default"><a name="ln4"></a> <i><span class="brown"># Copyright (C) 2007 Hirokazu Nemoto. All rights reserved.</span></i></span></li><li><span class="default"><a name="ln5"></a> </span></li><li><span class="default"><a name="ln6"></a> <b><span class="darkblue">require</span></b> <span class="red">'pathname'</span></span></li><li><span class="default"><a name="ln7"></a> <b><span class="darkblue">require</span></b> <span class="red">'win32ole'</span></span></li><li><span class="default"><a name="ln8"></a> </span></li><li><span class="default"><a name="ln9"></a> <b><span class="darkblue">require</span></b> <span class="red">'minicmd/utils/many_file_app'</span></span></li><li><span class="default"><a name="ln10"></a> </span></li><li><span class="default"><a name="ln11"></a> <b><span class="blue">class</span></b> ExcelInfoApp <span class="darkred">&lt;</span> ManyFileApp</span></li><li><span class="default"><a name="ln12"></a>         ExcelExt <span class="darkred">=</span> <span class="red">".xls"</span></span></li><li><span class="default"><a name="ln13"></a>         <span class="darkgreen">@@const_load_flag</span> <span class="darkred">=</span> <b><span class="blue">false</span></b></span></li><li><span class="default"><a name="ln14"></a>         </span></li><li><span class="default"><a name="ln15"></a>         <i><span class="brown"># 初期化</span></i></span></li><li><span class="default"><a name="ln16"></a>         <b><span class="blue">def</span></b> initialize</span></li><li><span class="default"><a name="ln17"></a>                 <b><span class="blue">super</span></b></span></li><li><span class="default"><a name="ln18"></a>                 </span></li><li><span class="default"><a name="ln19"></a>                 <span class="darkgreen">@fname_pattern</span> <span class="darkred">=</span> <span class="red">"*"</span> <span class="darkred">+</span> ExcelExt</span></li><li><span class="default"><a name="ln20"></a>                 <span class="darkgreen">@header_flag</span> <span class="darkred">=</span> <b><span class="blue">true</span></b></span></li><li><span class="default"><a name="ln21"></a>                 </span></li><li><span class="default"><a name="ln22"></a>                 <span class="darkgreen">@parser</span><span class="darkred">.</span>banner <span class="darkred">+=</span> <span class="red">" (ファイル|フォルダ) ..."</span></span></li><li><span class="default"><a name="ln23"></a>                 <span class="darkgreen">@parser</span><span class="darkred">.</span>separator<span class="darkred">(</span><span class="red">""</span><span class="darkred">)</span></span></li><li><span class="default"><a name="ln24"></a>         <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln25"></a>         </span></li><li><span class="default"><a name="ln26"></a>         <i><span class="brown"># 使用方法出力</span></i></span></li><li><span class="default"><a name="ln27"></a>         <i><span class="brown">#</span></i></span></li><li><span class="default"><a name="ln28"></a>         <i><span class="brown"># 継承元クラスのメソッドをオーバーライドしています。</span></i></span></li><li><span class="default"><a name="ln29"></a>         <b><span class="blue">def</span></b> usage</span></li><li><span class="default"><a name="ln30"></a>                 puts <span class="darkgreen">@parser</span><span class="darkred">.</span>help</span></li><li><span class="default"><a name="ln31"></a>                 puts <span class="darkgreen">@usage_msg_fixed_args</span></span></li><li><span class="default"><a name="ln32"></a>         <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln33"></a>         </span></li><li><span class="default"><a name="ln34"></a>         <i><span class="brown"># 複数ファイル処理</span></i></span></li><li><span class="default"><a name="ln35"></a>         <i><span class="brown">#</span></i></span></li><li><span class="default"><a name="ln36"></a>         <i><span class="brown"># 継承元クラスのメソッドをオーバーライドしています。</span></i></span></li><li><span class="default"><a name="ln37"></a>         <b><span class="blue">def</span></b> process_many_file</span></li><li><span class="default"><a name="ln38"></a>                 <span class="darkgreen">@xl</span> <span class="darkred">=</span> <b><span class="blue">nil</span></b></span></li><li><span class="default"><a name="ln39"></a>                 <b><span class="blue">begin</span></b></span></li><li><span class="default"><a name="ln40"></a>                         <i><span class="brown"># Excelアプリを起動します。</span></i></span></li><li><span class="default"><a name="ln41"></a>                         <span class="darkgreen">@xl</span> <span class="darkred">=</span> WIN32OLE<span class="darkred">.</span>new<span class="darkred">(</span><span class="red">'Excel.Application'</span><span class="darkred">)</span></span></li><li><span class="default"><a name="ln42"></a>                         <i><span class="brown"># 定数をロードします。</span></i></span></li><li><span class="default"><a name="ln43"></a>                         WIN32OLE<span class="darkred">.</span>const_load<span class="darkred">(</span><span class="darkgreen">@xl</span><span class="darkred">,</span> ExcelInfoApp<span class="darkred">)</span> <b><span class="blue">unless</span></b> <span class="darkgreen">@@const_load_flag</span></span></li><li><span class="default"><a name="ln44"></a>                         <span class="darkgreen">@@const_load_flag</span> <span class="darkred">=</span> <b><span class="blue">true</span></b></span></li><li><span class="default"><a name="ln45"></a>                         <i><span class="brown"># 継承元クラスの処理を呼び出します。</span></i></span></li><li><span class="default"><a name="ln46"></a>                         <b><span class="blue">super</span></b></span></li><li><span class="default"><a name="ln47"></a>                 <b><span class="blue">ensure</span></b></span></li><li><span class="default"><a name="ln48"></a>                         <i><span class="brown"># Excelアプリを終了します。</span></i></span></li><li><span class="default"><a name="ln49"></a>                         <span class="darkgreen">@xl</span><span class="darkred">.</span>Quit <b><span class="blue">if</span></b> <span class="darkgreen">@xl</span></span></li><li><span class="default"><a name="ln50"></a>                         <span class="darkgreen">@xl</span> <span class="darkred">=</span> <b><span class="blue">nil</span></b></span></li><li><span class="default"><a name="ln51"></a>                 <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln52"></a>         <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln53"></a>         </span></li><li><span class="default"><a name="ln54"></a>         <i><span class="brown"># 1ファイルの処理</span></i></span></li><li><span class="default"><a name="ln55"></a>         <i><span class="brown">#</span></i></span></li><li><span class="default"><a name="ln56"></a>         <i><span class="brown"># 継承元クラスのメソッドをオーバーライドしています。</span></i></span></li><li><span class="default"><a name="ln57"></a>         <b><span class="blue">def</span></b> process_one_file<span class="darkred">(</span>path<span class="darkred">)</span></span></li><li><span class="default"><a name="ln58"></a>                 book <span class="darkred">=</span> <b><span class="blue">nil</span></b></span></li><li><span class="default"><a name="ln59"></a>                 </span></li><li><span class="default"><a name="ln60"></a>                 <b><span class="blue">unless</span></b> is_excel_file?<span class="darkred">(</span>path<span class="darkred">)</span></span></li><li><span class="default"><a name="ln61"></a>                         puts <span class="red">"#{path} は、Excelファイルではありません。"</span></span></li><li><span class="default"><a name="ln62"></a>                         <b><span class="blue">return</span></b></span></li><li><span class="default"><a name="ln63"></a>                 <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln64"></a>                 </span></li><li><span class="default"><a name="ln65"></a>                 <b><span class="blue">begin</span></b></span></li><li><span class="default"><a name="ln66"></a>                         <i><span class="brown"># 絶対パスの取得</span></i></span></li><li><span class="default"><a name="ln67"></a>                         absolute_path <span class="darkred">=</span> get_absolute_path<span class="darkred">(</span>path<span class="darkred">)</span></span></li><li><span class="default"><a name="ln68"></a>                         <i><span class="brown"># ファイルを開きます。</span></i></span></li><li><span class="default"><a name="ln69"></a>                         book <span class="darkred">=</span> <span class="darkgreen">@xl</span><span class="darkred">.</span>Workbooks<span class="darkred">.</span>Open<span class="darkred">(</span>absolute_path<span class="darkred">)</span></span></li><li><span class="default"><a name="ln70"></a>                         <i><span class="brown"># シート数分ループします。</span></i></span></li><li><span class="default"><a name="ln71"></a>                         book<span class="darkred">.</span>Worksheets<span class="darkred">.</span>each <span class="red">{</span> <span class="darkred">|</span>sheet<span class="darkred">|</span></span></li><li><span class="default"><a name="ln72"></a>                                 puts_info<span class="darkred">(</span>path<span class="darkred">,</span> book<span class="darkred">,</span> sheet<span class="darkred">)</span></span></li><li><span class="default"><a name="ln73"></a>                         <span class="red">}</span></span></li><li><span class="default"><a name="ln74"></a>                 <b><span class="blue">rescue</span></b></span></li><li><span class="default"><a name="ln75"></a>                         puts <span class="red">"#{path} の読み込みに失敗しました。"</span></span></li><li><span class="default"><a name="ln76"></a>                         puts $<span class="darkred">!</span></span></li><li><span class="default"><a name="ln77"></a>                 <b><span class="blue">ensure</span></b></span></li><li><span class="default"><a name="ln78"></a>                         <i><span class="brown"># ファイルをクローズします。</span></i></span></li><li><span class="default"><a name="ln79"></a>                         book<span class="darkred">.</span>Close <b><span class="blue">if</span></b> book</span></li><li><span class="default"><a name="ln80"></a>                 <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln81"></a>         <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln82"></a>         </span></li><li><span class="default"><a name="ln83"></a>         private</span></li><li><span class="default"><a name="ln84"></a>         </span></li><li><span class="default"><a name="ln85"></a>         <i><span class="brown"># Excelファイルである事を確認する。</span></i></span></li><li><span class="default"><a name="ln86"></a>         <b><span class="blue">def</span></b> is_excel_file?<span class="darkred">(</span>path<span class="darkred">)</span></span></li><li><span class="default"><a name="ln87"></a>                 pathname <span class="darkred">=</span> Pathname<span class="darkred">.</span>new<span class="darkred">(</span>path<span class="darkred">)</span></span></li><li><span class="default"><a name="ln88"></a>                 <b><span class="blue">return</span></b> pathname<span class="darkred">.</span>extname <span class="darkred">==</span> ExcelExt</span></li><li><span class="default"><a name="ln89"></a>         <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln90"></a>         </span></li><li><span class="default"><a name="ln91"></a>         <i><span class="brown"># 絶対パスを取得します。</span></i></span></li><li><span class="default"><a name="ln92"></a>         <b><span class="blue">def</span></b> get_absolute_path<span class="darkred">(</span>fname<span class="darkred">)</span></span></li><li><span class="default"><a name="ln93"></a>                 fso <span class="darkred">=</span> WIN32OLE<span class="darkred">.</span>new<span class="darkred">(</span><span class="red">'Scripting.FileSystemObject'</span><span class="darkred">)</span></span></li><li><span class="default"><a name="ln94"></a>                 <b><span class="blue">return</span></b> fso<span class="darkred">.</span>GetAbsolutePathName<span class="darkred">(</span>fname<span class="darkred">)</span></span></li><li><span class="default"><a name="ln95"></a>         <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln96"></a>         </span></li><li><span class="default"><a name="ln97"></a>         <i><span class="brown"># シートのページ数を取得します。</span></i></span></li><li><span class="default"><a name="ln98"></a>         <i><span class="brown"># 参考：</span></i></span></li><li><span class="default"><a name="ln99"></a>         <i><span class="brown">#   [XL95] 印刷するページの総数を調べる方法</span></i></span></li><li><span class="default"><a name="ln100"></a>         <i><span class="brown">#   http://support.microsoft.com/kb/402754/JA/</span></i></span></li><li><span class="default"><a name="ln101"></a>         <b><span class="blue">def</span></b> get_page<span class="darkred">(</span>sheet<span class="darkred">)</span></span></li><li><span class="default"><a name="ln102"></a>                 <i><span class="brown"># Get.Documentでは、第2引数にシート名を渡すと、該当シートのページ数が返却されます。</span></i></span></li><li><span class="default"><a name="ln103"></a>                 <i><span class="brown"># 第2引数を指定しないと、アクティブなシートのページ数が返却されます。</span></i></span></li><li><span class="default"><a name="ln104"></a>                 <b><span class="blue">return</span></b> <span class="darkgreen">@xl</span><span class="darkred">.</span>ExecuteExcel4Macro<span class="darkred">(</span><span class="red">"Get.Document(50,\"#{sheet.Name}\")"</span><span class="darkred">).</span>to_i</span></li><li><span class="default"><a name="ln105"></a>         <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln106"></a>         </span></li><li><span class="default"><a name="ln107"></a>         <i><span class="brown"># 印刷の向きを取得します。</span></i></span></li><li><span class="default"><a name="ln108"></a>         <b><span class="blue">def</span></b> get_orientation<span class="darkred">(</span>pageSetup<span class="darkred">)</span></span></li><li><span class="default"><a name="ln109"></a>                 <b><span class="blue">case</span></b> pageSetup<span class="darkred">.</span>orientation</span></li><li><span class="default"><a name="ln110"></a>                 <b><span class="blue">when</span></b> ExcelInfoApp<span class="darkred">::</span>XlLandscape</span></li><li><span class="default"><a name="ln111"></a>                         result <span class="darkred">=</span> <span class="red">"横"</span></span></li><li><span class="default"><a name="ln112"></a>                 <b><span class="blue">when</span></b> ExcelInfoApp<span class="darkred">::</span>XlPortrait</span></li><li><span class="default"><a name="ln113"></a>                         result <span class="darkred">=</span> <span class="red">"縦"</span></span></li><li><span class="default"><a name="ln114"></a>                 <b><span class="blue">else</span></b></span></li><li><span class="default"><a name="ln115"></a>                         result <span class="darkred">=</span> pageSetup<span class="darkred">.</span>orientation</span></li><li><span class="default"><a name="ln116"></a>                 <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln117"></a>                 <b><span class="blue">return</span></b> result</span></li><li><span class="default"><a name="ln118"></a>         <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln119"></a>         </span></li><li><span class="default"><a name="ln120"></a>         <i><span class="brown"># 用紙サイズを取得します。</span></i></span></li><li><span class="default"><a name="ln121"></a>         <b><span class="blue">def</span></b> get_paper_size<span class="darkred">(</span>pageSetup<span class="darkred">)</span></span></li><li><span class="default"><a name="ln122"></a>                 <b><span class="blue">case</span></b> pageSetup<span class="darkred">.</span>paperSize</span></li><li><span class="default"><a name="ln123"></a>                 <b><span class="blue">when</span></b> ExcelInfoApp<span class="darkred">::</span>XlPaperA3</span></li><li><span class="default"><a name="ln124"></a>                         result <span class="darkred">=</span> <span class="red">"A3"</span></span></li><li><span class="default"><a name="ln125"></a>                 <b><span class="blue">when</span></b> ExcelInfoApp<span class="darkred">::</span>XlPaperA4</span></li><li><span class="default"><a name="ln126"></a>                         result <span class="darkred">=</span> <span class="red">"A4"</span></span></li><li><span class="default"><a name="ln127"></a>                 <b><span class="blue">when</span></b> ExcelInfoApp<span class="darkred">::</span>XlPaperA4Small</span></li><li><span class="default"><a name="ln128"></a>                         result <span class="darkred">=</span> <span class="red">"A4（小型）"</span></span></li><li><span class="default"><a name="ln129"></a>                 <b><span class="blue">else</span></b></span></li><li><span class="default"><a name="ln130"></a>                         result <span class="darkred">=</span> pageSetup<span class="darkred">.</span>paperSize</span></li><li><span class="default"><a name="ln131"></a>                 <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln132"></a>                 <b><span class="blue">return</span></b> result</span></li><li><span class="default"><a name="ln133"></a>         <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln134"></a>         </span></li><li><span class="default"><a name="ln135"></a>         <i><span class="brown"># ワークシートの情報を出力します。</span></i></span></li><li><span class="default"><a name="ln136"></a>         <b><span class="blue">def</span></b> puts_info<span class="darkred">(</span>path<span class="darkred">,</span> book<span class="darkred">,</span> sheet<span class="darkred">)</span></span></li><li><span class="default"><a name="ln137"></a>                 header <span class="darkred">=</span> Array<span class="darkred">.</span>new</span></li><li><span class="default"><a name="ln138"></a>                 data <span class="darkred">=</span> Array<span class="darkred">.</span>new</span></li><li><span class="default"><a name="ln139"></a>                 pageSetup <span class="darkred">=</span> sheet<span class="darkred">.</span>pageSetup</span></li><li><span class="default"><a name="ln140"></a>                 </span></li><li><span class="default"><a name="ln141"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"ファイル名"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln142"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>path<span class="darkred">)</span></span></li><li><span class="default"><a name="ln143"></a>                 </span></li><li><span class="default"><a name="ln144"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"シート名"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln145"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>sheet<span class="darkred">.</span>Name<span class="darkred">)</span></span></li><li><span class="default"><a name="ln146"></a>                 </span></li><li><span class="default"><a name="ln147"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"ページ数"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln148"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>get_page<span class="darkred">(</span>sheet<span class="darkred">))</span></span></li><li><span class="default"><a name="ln149"></a>                 </span></li><li><span class="default"><a name="ln150"></a>                 <i><span class="brown">### ページ関連</span></i></span></li><li><span class="default"><a name="ln151"></a>                 </span></li><li><span class="default"><a name="ln152"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"印刷の向き"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln153"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>get_orientation<span class="darkred">(</span>pageSetup<span class="darkred">))</span></span></li><li><span class="default"><a name="ln154"></a>                 </span></li><li><span class="default"><a name="ln155"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"印刷時倍率"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln156"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>zoom<span class="darkred">)</span></span></li><li><span class="default"><a name="ln157"></a>                 </span></li><li><span class="default"><a name="ln158"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"印刷時縦方向ページ数"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln159"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>FitToPagesTall<span class="darkred">)</span></span></li><li><span class="default"><a name="ln160"></a>                 </span></li><li><span class="default"><a name="ln161"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"印刷時横方向ページ数"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln162"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>FitToPagesWide<span class="darkred">)</span></span></li><li><span class="default"><a name="ln163"></a>                 </span></li><li><span class="default"><a name="ln164"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"用紙サイズ"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln165"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>get_paper_size<span class="darkred">(</span>pageSetup<span class="darkred">))</span></span></li><li><span class="default"><a name="ln166"></a>                 </span></li><li><span class="default"><a name="ln167"></a>                 <i><span class="brown">### 余白関連</span></i></span></li><li><span class="default"><a name="ln168"></a>                 points <span class="darkred">=</span> <span class="darkgreen">@xl</span><span class="darkred">.</span>CentimetersToPoints<span class="darkred">(</span><span class="purple">1</span><span class="darkred">)</span></span></li><li><span class="default"><a name="ln169"></a>                 </span></li><li><span class="default"><a name="ln170"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"上マージン"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln171"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>topMargin <span class="darkred">/</span> points<span class="darkred">)</span></span></li><li><span class="default"><a name="ln172"></a>                 </span></li><li><span class="default"><a name="ln173"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"下マージン"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln174"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>bottomMargin <span class="darkred">/</span> points<span class="darkred">)</span></span></li><li><span class="default"><a name="ln175"></a>                 </span></li><li><span class="default"><a name="ln176"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"左マージン"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln177"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>leftMargin <span class="darkred">/</span> points<span class="darkred">)</span></span></li><li><span class="default"><a name="ln178"></a>                 </span></li><li><span class="default"><a name="ln179"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"右マージン"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln180"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>rightMargin <span class="darkred">/</span> points<span class="darkred">)</span></span></li><li><span class="default"><a name="ln181"></a>                 </span></li><li><span class="default"><a name="ln182"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"ヘッダー余白"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln183"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>HeaderMargin <span class="darkred">/</span> points<span class="darkred">)</span></span></li><li><span class="default"><a name="ln184"></a>                 </span></li><li><span class="default"><a name="ln185"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"フッター余白"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln186"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>FooterMargin <span class="darkred">/</span> points<span class="darkred">)</span></span></li><li><span class="default"><a name="ln187"></a>                 </span></li><li><span class="default"><a name="ln188"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"横ページ中央揃え"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln189"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>CenterHorizontally<span class="darkred">)</span></span></li><li><span class="default"><a name="ln190"></a>                 </span></li><li><span class="default"><a name="ln191"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"縦ページ中央揃え"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln192"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>CenterVertically<span class="darkred">)</span></span></li><li><span class="default"><a name="ln193"></a>                 </span></li><li><span class="default"><a name="ln194"></a>                 <i><span class="brown">### ヘッダー・フッター関連</span></i></span></li><li><span class="default"><a name="ln195"></a>                 </span></li><li><span class="default"><a name="ln196"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"左ヘッダー"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln197"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>leftHeader<span class="darkred">)</span></span></li><li><span class="default"><a name="ln198"></a>                 </span></li><li><span class="default"><a name="ln199"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"中央ヘッダー"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln200"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>centerHeader<span class="darkred">)</span></span></li><li><span class="default"><a name="ln201"></a>                 </span></li><li><span class="default"><a name="ln202"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"右ヘッダー"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln203"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>rightHeader<span class="darkred">)</span></span></li><li><span class="default"><a name="ln204"></a>                 </span></li><li><span class="default"><a name="ln205"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"左フッター"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln206"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>leftFooter<span class="darkred">)</span></span></li><li><span class="default"><a name="ln207"></a>                 </span></li><li><span class="default"><a name="ln208"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"中央フッター"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln209"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>centerFooter<span class="darkred">)</span></span></li><li><span class="default"><a name="ln210"></a>                 </span></li><li><span class="default"><a name="ln211"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"右フッター"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln212"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>rightFooter<span class="darkred">)</span></span></li><li><span class="default"><a name="ln213"></a>                 </span></li><li><span class="default"><a name="ln214"></a>                 <i><span class="brown">### シート関連</span></i></span></li><li><span class="default"><a name="ln215"></a>                 </span></li><li><span class="default"><a name="ln216"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"行タイトル"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln217"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>PrintTitleRows<span class="darkred">)</span></span></li><li><span class="default"><a name="ln218"></a>                 </span></li><li><span class="default"><a name="ln219"></a>                 header<span class="darkred">.</span>push<span class="darkred">(</span><span class="red">"列タイトル"</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln220"></a>                 data<span class="darkred">.</span>push<span class="darkred">(</span>pageSetup<span class="darkred">.</span>PrintTitleColumns<span class="darkred">)</span></span></li><li><span class="default"><a name="ln221"></a>                 </span></li><li><span class="default"><a name="ln222"></a>                 puts header<span class="darkred">.</span>join<span class="darkred">(</span><span class="red">","</span><span class="darkred">)</span> <b><span class="blue">if</span></b> <span class="darkgreen">@header_flag</span></span></li><li><span class="default"><a name="ln223"></a>                 puts data<span class="darkred">.</span>join<span class="darkred">(</span><span class="red">","</span><span class="darkred">)</span></span></li><li><span class="default"><a name="ln224"></a>                 </span></li><li><span class="default"><a name="ln225"></a>                 <span class="darkgreen">@header_flag</span> <span class="darkred">=</span> <b><span class="blue">false</span></b></span></li><li><span class="default"><a name="ln226"></a>         <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln227"></a> <b><span class="blue">end</span></b></span></li><li><span class="default"><a name="ln228"></a> </span></li><li><span class="default"><a name="ln229"></a> <b><span class="blue">if</span></b> <b><span class="blue">__FILE__</span></b> <span class="darkred">==</span> <span class="darkgreen">$0</span></span></li><li><span class="default"><a name="ln230"></a>         app <span class="darkred">=</span> ExcelInfoApp<span class="darkred">.</span>new</span></li><li><span class="default"><a name="ln231"></a>         app<span class="darkred">.</span>main<span class="darkred">(</span>ARGV<span class="darkred">)</span></span></li><li><span class="default"><a name="ln232"></a> <b><span class="blue">end</span></b></ol></pre></div>
<script type="text/javascript">
jQuery(function() { // prettyPrint(); });
</script>
</div><a class="pull-right btn btn-mini" rel="nofollow" href="/projects/rubyminicmd/svn/view/">旧リポジトリブラウザで表示</a>
<div class="right-clear"></div>

</td>
</tr>
</tbody>
</table><!-- #frame -->
<div class="both-clear"></div>


<!-- START: page_foot -->
<footer id="osdnsitefooter">
<div class="cols">
<div class="col first">
<span>About SourceForge.JP</span>
<ul><li><a href="/docs/SourceForge.JP%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6">About SourceForge.JP</a></li>
<li><a href="http://osdn.jp/about.shtml">About OSDN</a></li><li><a rel="nofollow" href="http://osdn.jp/privacy.shtml">Privacy</a></li>
<li><a rel="nofollow" href="http://osdn.jp/pp.shtml">Protection of individual info policy</a></li>
</ul>
</div>
<div class="col">
<span>Find Software</span>
<ul>
<li><a href="/search/">Search</a></li>
<li><a href="/softwaremap/">Find by Categories</a></li>
<li><a href="/top/topdl.php?type=downloads_day">Download Ranking</a></li>
<li><a href="/top/overview.php">Project Ranking</a></li>
</ul>
</div>
<div class="col">
<span>Develop Software</span>
<ul>
<li><a href="/develop/">Create Project</a></li>
<li><a href="/people/">Project Help Wanted</a></li>
<li><a href="/news/recent-approved.php">Recently Registered Project</a></li>
</ul>
</div>
<div class="col">
<span>Community</span>
<ul>
<li><a href="http://b.sourceforge.jp/">SourceForge.JP Blog</a></li><li>
<li><a href="/news/?group_id=1">Site Announce</a></li>
<li><a href="http://twitter.com/sourceforgejp">@sourceforgejp on Twitter</a></li>
<li><a href="http://friendfeed.com/sourceforgejp">SF.JP on FriendFeed</a></li>
<li><a href="http://slashdot.jp/">Slashdot.JP</a></li>
</ul>
</div>
<div class="col">
<span>Help</span>
<ul>
<li><a rel="nofollow" href="/tos.php">Term of Use</a></li>
<li><a href="/docs/FrontPage">Help</a></li>
<li><a rel="nofollow" href="/docs/SourceForge.JP%E3%81%AE%E9%80%A3%E7%B5%A1%E5%85%88">Contact Us</a></li>
<li><a href="http://osdn.jp/advertise/">Advertisement publishing</a></li><li><a rel="nofollow" href="/reportspam.php">Report Abuse/spam</a></li>
</ul>
</div>
<div class="spacer"></div>
</div>
<div style="width: 600px; margin-left: auto; margin-right: auto; margin-bottom: 10px;">
SourceForge.JP is a Japanese version of SourceForge.net. For developments that are not related to Japan, we recommend you to use <a href="http://sourceforge.net">SourceForge.net</a>.
</div>
<div id="copyright">
Copyright &copy;<a href="http://osdn.jp/">OSDN Corporation</a> All rights reserved.
</div></footer><!-- #osdnsitefooter -->
<div id="fb-root"></div>
</body></html>
