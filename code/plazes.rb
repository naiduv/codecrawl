<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
    <meta http-equiv="generator" content="WebSVN [trunk]" /> <!-- leave this for stats -->
    <link rel="shortcut icon" type="image/x-icon" href="/templates/calm/images/favicon.ico" />
    <link type="text/css" href="/templates/calm/styles.css" rel="stylesheet" media="screen" />
    <link type="text/css" href="/templates/calm/star-light/star-light.css" rel="stylesheet" media="screen" />
    <!--[if gte IE 5.5000]>
    <script type="text/javascript" src="/templates/calm/png.js"></script>
    <style type="text/css" media="screen">
    tbody tr td { padding:1px 0 }
    #wrap h2 { padding:10px 5px 0 5px; margin-bottom:-8px }
    </style>
    <![endif]-->
    <title>
         WebSVN
            - Plazes
               - Rev 46
            - /Ruby/RubyForPlazes/plazes.rb
    </title>
    <script type="text/javascript">
    //<![CDATA[
         function getPath()
         {
         	return '';
         }
         
         function checkCB(chBox)
         {
            count = 0
            first = null
            f = chBox.form
            for (i = 0 ; i < f.elements.length ; i++)
            if (f.elements[i].type == 'checkbox' && f.elements[i].checked)
            {
               if (first == null && f.elements[i] != chBox)
                  first = f.elements[i]
               count += 1
            }
            
            if (count > 2) 
            {
               first.checked = false
               count -= 1
            }
         }
    //]]>
    </script>
    <script type="text/javascript" src="/templates/calm/collapse.js"></script>
    </head>
    <body>
    <div id="container">
<div id="select"><form action="/wsvn" method="post" id="projectform"><div><input type="hidden" name="selectproj" value="1" /><input type="hidden" name="op" value="form" /><select name="repname" onchange="javascript:this.form.submit();"><option value="Charlottetown Transit Map">Charlottetown Transit Map</option><option value="Plazes" selected="selected">Plazes</option><option value="Jaiku">Jaiku</option><option value="PEI Public Data">PEI Public Data</option><option value="Charlottetown RSS">Charlottetown RSS</option><option value="GPS">GPS</option><option value="OPAC">OPAC</option><option value="MemberDirect">MemberDirect</option><option value="Misc">Misc</option></select><span class="submit"><input type="submit" value="Go" /></span></div></form></div>
<h1><a href="/wsvn/?" title="Project home">Subversion&nbsp;Repositories</a> <span>Plazes</span></h1>
<h2 class="path" style="margin:0 2% 15px 2%;">[<a href="/wsvn/Plazes/?rev=0">/</a>] [<a href="/wsvn/Plazes/Ruby/?rev=0">Ruby/</a>] [<a href="/wsvn/Plazes/Ruby/RubyForPlazes/?rev=0">RubyForPlazes/</a>] [<b>plazes.rb</b>] - Rev 46</h2>
<p>
<span class="diff"><a href="/wsvn/Plazes/Ruby/RubyForPlazes/plazes.rb?op=diff&amp;rev=0">Compare with Previous</a></span> &#124;
<span class="blame"><a href="/wsvn/Plazes/Ruby/RubyForPlazes/plazes.rb?op=blame&amp;rev=0">Blame</a></span> &#124;
<span class="log"><a href="/wsvn/Plazes/Ruby/RubyForPlazes/plazes.rb?op=log&amp;rev=0&amp;isdir=0">View&nbsp;Log</a></span>
</p>
    <div class="listing">
<pre>=begin rdoc
= plazes.rb - Plazes.com support library
&nbsp;
== Description
&nbsp;
The Plazes module provides programatic access to the Plazes.com system. The 
following APIs are supported:
&nbsp;
* {Plazes API 1.0}[http://beta.plazes.com/api/plazes/]
* {WhereAmI API}[http://www.codeplaze.com/documentation/whereami/]
* {Launcher API}[http://www.codeplaze.com/api/launcher/]
&nbsp;
You can register a {developer key}[http://beta.plazes.com/api/plazes/dev_key_register.php] 
for the Plazes and WhereAmI APIs. For the Launcher API you need a special key 
which can be requested through a support ticket. You can also try to use the key
used by the Python launcher, found at http://kybkreis.org/wiki/index.php/PyPlazes
&nbsp;
For additional information and documentation, see http://ruk.ca/wiki/RubyforPlazes
&nbsp;
== Legal
&nbsp;
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at
your option) any later version.
&nbsp;
This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.
&nbsp;
You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
USA
&nbsp;
Version::		0.7, April, 2006
Author:: 		Peter Rukavina (mailto:peter@rukavina.net)
Author:: 		Mark Wubben (http://novemberborn.net)
Copyright::	Copyright (c) 2005 - 2006 by Reinvented Inc and Mark Wubben.
License:: 	http://www.fsf.org/licensing/licenses/gpl.txt GNU Public License
&nbsp;
== Examples
&nbsp;
No examples added yet.
=end
&nbsp;
module Plazes
  $LOAD_PATH &lt;&lt; File.expand_path(File.dirname(__FILE__) + &quot;/lib&quot;)
&nbsp;
	# Include XML-RPC client capabilities.
	require 'xmlrpc/client'
&nbsp;
	# Include modified methods for some of the standard Ruby XML-RPC methods to make
	# the XML-RPC calls work with the Plazes.com XML-RPC server.
 	require 'xmlrpc-plazes'
&nbsp;
 	# Load classes
 	require 'base'
 	require 'session'
 	require 'abstractplaze'
 	require 'plaze'
 	require 'basicplaze'
 	require 'launcherplaze'
 	require 'info'
 	require 'traze'
 	require 'baseuser'
 	require 'user'
 	require 'friend'
 	require 'buddy'
 	require 'comment'
 	require 'photo'
end</pre>    </div>
<p>
<span class="diff"><a href="/wsvn/Plazes/Ruby/RubyForPlazes/plazes.rb?op=diff&amp;rev=0">Compare with Previous</a></span> &#124;
<span class="blame"><a href="/wsvn/Plazes/Ruby/RubyForPlazes/plazes.rb?op=blame&amp;rev=0">Blame</a></span> &#124;
<span class="log"><a href="/wsvn/Plazes/Ruby/RubyForPlazes/plazes.rb?op=log&amp;rev=0&amp;isdir=0">View&nbsp;Log</a></span>
</p>
  </div>
  <div id="footer">
    <p style="padding:0; margin:0"><small>powered by: <a href="http://websvn.tigris.org">WebSVN [trunk]</a></small></p>
  </div>
</body>
</html>
