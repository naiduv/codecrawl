<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Source Code spree/core/spec/models/spree/product/scopes_spec.rb | Ritz Consultant</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <script type="text/javascript" src="/css/shCore.js"></script>
        <script type="text/javascript" src="/css/shBrushPhp.js"></script>
		<script type="text/javascript" src="/css/shBrushSql.js"></script>
		<script type="text/javascript" src="/css/shBrushXml.js"></script>
		<script type="text/javascript" src="/css/shBrushJScript.js"></script>
		<script type="text/javascript" src="/css/shBrushCss.js"></script>
		<script type="text/javascript" src="/css/shBrushCSharp.js"></script>
		<script type="text/javascript" src="/css/shBrushJava.js"></script>
		<script type="text/javascript" src="/css/shBrushBash.js"></script>
        <link type="text/css" rel="stylesheet" href="/css/shCore.css"/>
		<link type="text/css" rel="stylesheet" href="/css/shThemeDefault.css"/>
        <script type="text/javascript">
            SyntaxHighlighter.config.clipboardSwf = '/css/clipboard.swf';
            SyntaxHighlighter.all();
        </script>
				<link href="styles/default/default.css" rel="stylesheet" type="text/css" media="screen" />
		
		<!-- Makes the file tree(s) expand/collapsae dynamically -->
		<script src="jquery-1.3.2" type="text/javascript"></script>
		<script src="php_file_tree_jquery.js" type="text/javascript"></script>
		<script type="text/javascript">
	var _gaq = _gaq || [];
	_gaq.push(['_setAccount', 'UA-43488579-1']);
	_gaq.push(['_trackPageview']);
	(function()
		{
			var ga = document.createElement('script');
			ga.type = 'text/javascript';
			ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
			var s = document.getElementsByTagName('script')[0];
			s.parentNode.insertBefore(ga, s);
		})();
</script>
        <style type="text/css">
            * {
                margin: 0;
                padding: 0;
            }
            body {
                color: #2e2e2e;
                font-family: Tahoma, Geneva, sans-serif;
                font-size: 14px;
                line-height: 18px;
                background-color: #FFF;
            }
            #wrapper {
                width: 100%;
                margin: 0 auto;
                background-color: #FFF;
            }
            .source_title {
                font-size: 12px;
                text-indent: 5px;
                border-bottom-width: 2px;
                border-bottom-style: solid;
                border-bottom-color: #CCC;
                height: 22px;
                padding-top: 6px;
                padding-right: 2px;
                padding-left: 2px;
                margin-bottom: 4px;
                background-color: #EEE;
				width:100%
            }
            .status {
                font-size: 12px;
                text-indent: 5px;
                border-top-width: 2px;
                border-top-style: solid;
                border-top-color: #CCC;
                height: 22px;
                padding-top: 6px;
                padding-right: 6px;
                padding-left: 2px;
                margin-top: 4px;
                text-align: right;
                background-color: #EEE;
            }
            .title {
                text-transform: capitalize;
            }
            pre {
                margin: 0px;
                padding: 0px;
            }
			.feedburnerFeedBlock ul li span{
				line-height: 3;
			}

			.frame-list {
				line-height:28px;
				font-size:18px;
				padding-left:10px;
			}
			.frame-list li a:hover{
				line-height:26px;
				font-size:18px;
				background-color:yellow;
			}
			.gsearch {
				clear:both;
				float:right;
			}
        </style>
    </head>
    <body>
        <div id="wrapper">
		<div id="likebox-wrapper"><iframe src="//www.facebook.com/plugins/likebox.php?href=https%3A%2F%2Fwww.facebook.com%2Fritzconsultant&amp;width=1000&amp;height=180&amp;colorscheme=light&amp;show_faces=true&amp;header=false&amp;stream=false&amp;show_border=true" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width: 100%; height:180px;" allowTransparency="true"></iframe></div>
            <div class="source_title"> Location: <a href='/code'>Source Code</a> / <a href='/code/spree/'>spree</a> / <a href='/code/spree/core/'>core</a> / <a href='/code/spree/core/spec/'>spec</a> / <a href='/code/spree/core/spec/models/'>models</a> / <a href='/code/spree/core/spec/models/spree/'>spree</a> / <a href='/code/spree/core/spec/models/spree/product/'>product</a> / scopes_spec.rb <div style='float:right;'><a href="https://twitter.com/ritzcons" class="twitter-follow-button" data-show-count="true" data-lang="en">Follow @ritzcons</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script></div></div> 

						<div class='fex' style=' clear:both;float:left;width:15%; padding-left:5px;'>
			<a href='scopes_spec.rb'>scopes_spec.rb</a><br>			<br/>
			<script type="text/javascript" language="javascript"> var aax_size='160x600'; var aax_pubname = 'ritzconsultan-21'; var aax_src='302'; </script><script type="text/javascript" language="javascript" src="http://c.amazon-adsystem.com/aax2/assoc.js"></script>
			<br/>
			<div>
			<script type="text/javascript">
  ( function() {
    if (window.CHITIKA === undefined) { window.CHITIKA = { 'units' : [] }; };
    var unit = {"publisher":"RitzConsultant","width":160,"height":600,"sid":"Chitika Default"};
    var placement_id = window.CHITIKA.units.length;
    window.CHITIKA.units.push(unit);
    document.write('<div id="chitikaAdBlock-' + placement_id + '"></div>');
    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.src = '//cdn.chitika.net/getads.js';
    try { document.getElementsByTagName('head')[0].appendChild(s); } catch(e) { document.write(s.outerHTML); }
}());
</script>
			</div>
			</div>
            <div style="overflow: auto;float:left; width:84%">
<pre class="brush: php;">
require 'spec_helper'

describe &quot;Product scopes&quot; do
  let!(:product) { create(:product) }

  context &quot;A product assigned to parent and child taxons&quot; do
    before do
      @taxonomy = create(:taxonomy)
      @root_taxon = @taxonomy.root

      @parent_taxon = create(:taxon, :name =&gt; 'Parent', :taxonomy_id =&gt; @taxonomy.id, :parent =&gt; @root_taxon)
      @child_taxon = create(:taxon, :name =&gt;'Child 1', :taxonomy_id =&gt; @taxonomy.id, :parent =&gt; @parent_taxon)
      @parent_taxon.reload # Need to reload for descendents to show up

      product.taxons &lt;&lt; @parent_taxon
      product.taxons &lt;&lt; @child_taxon
    end

    it &quot;calling Product.in_taxon returns products in child taxons&quot; do
      product.taxons -= [@child_taxon]
      product.taxons.count.should == 1

      Spree::Product.in_taxon(@parent_taxon).should include(product)
    end

    it &quot;calling Product.in_taxon should not return duplicate records&quot; do
      Spree::Product.in_taxon(@parent_taxon).to_a.count.should == 1
    end

    it &quot;orders products based on their ordering within the classification&quot; do
      product_2 = create(:product)
      product_2.taxons &lt;&lt; @parent_taxon

      product_root_classification = Spree::Classification.find_by(:taxon =&gt; @parent_taxon, :product =&gt; product)
      product_root_classification.update_column(:position, 1)

      product_2_root_classification = Spree::Classification.find_by(:taxon =&gt; @parent_taxon, :product =&gt; product_2)
      product_2_root_classification.update_column(:position, 2)

      Spree::Product.in_taxon(@parent_taxon).should == [product, product_2]
      product_2_root_classification.insert_at(1)
      Spree::Product.in_taxon(@parent_taxon).should == [product_2, product]
    end
  end

  context '#add_simple_scopes' do
    let(:simple_scopes) { [:ascend_by_updated_at, :descend_by_name] }

    before do
      Spree::Product.add_simple_scopes(simple_scopes)
    end

    context 'define scope' do
      context 'ascend_by_updated_at' do
        context 'on class' do
          it { Spree::Product.ascend_by_updated_at.to_sql.should eq Spree::Product.order(&quot;#{Spree::Product.quoted_table_name}.updated_at ASC&quot;).to_sql }
        end

        context 'on ActiveRecord::Relation' do
          it { Spree::Product.limit(2).ascend_by_updated_at.to_sql.should eq Spree::Product.limit(2).order(&quot;#{Spree::Product.quoted_table_name}.updated_at ASC&quot;).to_sql }
          it { Spree::Product.limit(2).ascend_by_updated_at.to_sql.should eq Spree::Product.ascend_by_updated_at.limit(2).to_sql }
        end
      end

      context 'descend_by_name' do
        context 'on class' do
          it { Spree::Product.descend_by_name.to_sql.should eq Spree::Product.order(&quot;#{Spree::Product.quoted_table_name}.name DESC&quot;).to_sql }
        end

        context 'on ActiveRecord::Relation' do
          it { Spree::Product.limit(2).descend_by_name.to_sql.should eq Spree::Product.limit(2).order(&quot;#{Spree::Product.quoted_table_name}.name DESC&quot;).to_sql }
          it { Spree::Product.limit(2).descend_by_name.to_sql.should eq Spree::Product.descend_by_name.limit(2).to_sql }
        end
      end
    end
  end
end
</pre></div>


            <div class="status" style='clear:both;'>
			All Rights Reserve By Respective Code Owner | <a href='http://www.ritzcons.com/blog/'>Ritz Consultant Blog</a> | <a href='http://www.ritzcons.com/company/'>Search Company at Ritz Consultant</a> | <a href='http://www.ritzcons.com/jobs/'>Jobs by Ritz Consultant</a>
			</div>
        </div>
    </body>
</html>
