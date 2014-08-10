<!DOCTYPE html>
<html>
<head>
  <title>Ruby MRI/lib/mathn.rb</title>
  <meta charset="utf-8">
  <link href="/stylesheets/style.css" rel="stylesheet" type="text/css">
  <link rel="shortcut icon" href="/favicon.ico">
  <meta name="description" content="Ruby Cross Reference, a hypertext guide to Ruby MRI source code.">
</head>

<body><div id="wrapper" class="">

<header>
  <nav>
    <ul>
      
      <li><span class="modes-sel">source navigation</span></li>
      <li><a class="modes" href="/mri/ident">identifier search</a></li>
      <li><a class="modes" href="/mri/search">general search</a></li>
      <li><a class="modes" href="/mri/diff/lib/mathn.rb">diff markup</a></li>
    </ul>
  </nav>
  <h1><a href="/">The Ruby Cross Reference</a></h1>
  <div class="push"></div>
</header>

<div id="variables">
  <span class="variable">Implementation:</span>
    <span class="var-sel">mri</span> <a class="varlink" href="/jruby/source">jruby</a> <a class="varlink" href="/rubinius/source">rubinius</a> 
  <br/>

  
  <span class="variable">Version:</span>
    <a class="varlink" href="/mri/source/lib/mathn.rb?v=1.8.7-p374">1.8.7-p374</a> <a class="varlink" href="/mri/source/lib/mathn.rb?v=1.9.1-p431">1.9.1-p431</a> <a class="varlink" href="/mri/source/lib/mathn.rb?v=1.9.2-p381">1.9.2-p381</a> <a class="varlink" href="/mri/source/lib/mathn.rb?v=1.9.3-p547">1.9.3-p547</a> <a class="varlink" href="/mri/source/lib/mathn.rb?v=2.0.0-p481">2.0.0-p481</a> <a class="varlink" href="/mri/source/lib/mathn.rb?v=2.1.0-p0">2.1.0-p0</a> <a class="varlink" href="/mri/source/lib/mathn.rb?v=2.1.1">2.1.1</a> <a class="varlink" href="/mri/source/lib/mathn.rb?v=2.1.2">2.1.2</a> <span class="var-sel">HEAD</span> 
  <br/>
  
</div>

<h2 id="banner"><span class="banner"><a class="banner" href="/mri/source/">Ruby MRI</a>/&#x200B;<a class="banner" href="/mri/source/lib/">lib</a>/&#x200B;<a class="banner" href="/mri/source/lib/mathn.rb">mathn.rb</a></span></h2>
<pre class="file">
<a class="line" id="001">001</a> <span class="comment">#--</span>
<a class="line" id="002">002</a> <span class="comment"># $Release Version: 0.5 $</span>
<a class="line" id="003">003</a> <span class="comment"># $Revision: 1.1.1.1.4.1 $</span>
<a class="line" id="004">004</a> 
<a class="line" id="005">005</a> <span class="comment">##</span>
<a class="line" id="006">006</a> <span class="comment"># = mathn</span>
<a class="line" id="007">007</a> <span class="comment">#</span>
<a class="line" id="008">008</a> <span class="comment"># mathn is a library for changing the way Ruby does math.  If you need</span>
<a class="line" id="009">009</a> <span class="comment"># more precise rounding with multiple division or exponentiation</span>
<a class="line" id="010">010</a> <span class="comment"># operations, then mathn is the right tool.</span>
<a class="line" id="011">011</a> <span class="comment">#</span>
<a class="line" id="012">012</a> <span class="comment"># Without mathn:</span>
<a class="line" id="013">013</a> <span class="comment">#</span>
<a class="line" id="014">014</a> <span class="comment">#   3 / 2 =&gt; 1 # Integer</span>
<a class="line" id="015">015</a> <span class="comment">#</span>
<a class="line" id="016">016</a> <span class="comment"># With mathn:</span>
<a class="line" id="017">017</a> <span class="comment">#</span>
<a class="line" id="018">018</a> <span class="comment">#   3 / 2 =&gt; 3/2 # Rational</span>
<a class="line" id="019">019</a> <span class="comment">#</span>
<a class="line" id="020">020</a> <span class="comment"># mathn features late rounding and lacks truncation of intermediate results:</span>
<a class="line" id="021">021</a> <span class="comment">#</span>
<a class="line" id="022">022</a> <span class="comment"># Without mathn:</span>
<a class="line" id="023">023</a> <span class="comment">#</span>
<a class="line" id="024">024</a> <span class="comment">#   20 / 9 * 3 * 14 / 7 * 3 / 2 # =&gt; 18</span>
<a class="line" id="025">025</a> <span class="comment">#</span>
<a class="line" id="026">026</a> <span class="comment"># With mathn:</span>
<a class="line" id="027">027</a> <span class="comment">#</span>
<a class="line" id="028">028</a> <span class="comment">#   20 / 9 * 3 * 14 / 7 * 3 / 2 # =&gt; 20</span>
<a class="line" id="029">029</a> <span class="comment">#</span>
<a class="line" id="030">030</a> <span class="comment">#</span>
<a class="line" id="031">031</a> <span class="comment"># When you require 'mathn', the libraries for Prime, CMath, Matrix and Vector</span>
<a class="line" id="032">032</a> <span class="comment"># are also loaded.</span>
<a class="line" id="033">033</a> <span class="comment">#</span>
<a class="line" id="034">034</a> <span class="comment"># == Copyright</span>
<a class="line" id="035">035</a> <span class="comment">#</span>
<a class="line" id="036">036</a> <span class="comment"># Author: Keiju ISHITSUKA (SHL Japan Inc.)</span>
<a class="line" id="037">037</a> <span class="comment">#--</span>
<a class="line" id="038">038</a> <span class="comment"># class Numeric follows to make this documentation findable in a reasonable</span>
<a class="line" id="039">039</a> <span class="comment"># location</span>
<a class="line" id="040">040</a> 
<a class="line" id="041">041</a> <span class='reserved'>class</span> <a class="ident" href="/mri/ident?i=Numeric">Numeric</a>; <span class='reserved'>end</span>
<a class="line" id="042">042</a> 
<a class="line" id="043">043</a> require "<a class="include" href="/mri/source/lib/cmath.rb">cmath.rb</a>"
<a class="line" id="044">044</a> require "<a class="include" href="/mri/source/lib/matrix.rb">matrix.rb</a>"
<a class="line" id="045">045</a> require "<a class="include" href="/mri/source/lib/prime.rb">prime.rb</a>"
<a class="line" id="046">046</a> 
<a class="line" id="047">047</a> require "mathn/rational"
<a class="line" id="048">048</a> require "mathn/complex"
<a class="line" id="049">049</a> 
<a class="line" id="050">050</a> <span class='reserved'>unless</span> <span class='reserved'>defined?</span>(<a class="ident" href="/mri/ident?i=Math">Math</a>.exp!)
<a class="line" id="051">051</a>   <a class="ident" href="/mri/ident?i=Object">Object</a>.<a class="ident" href="/mri/ident?i=instance_eval">instance_eval</a>{<a class="ident" href="/mri/ident?i=remove_const">remove_const</a> <span class="string">:Math</span>}
<a class="line" id="052">052</a>   <a class="ident" href="/mri/ident?i=Math">Math</a> = <a class="ident" href="/mri/ident?i=CMath">CMath</a> <span class="comment"># :nodoc:</span>
<a class="line" id="053">053</a> <span class='reserved'>end</span>
<a class="line" id="054">054</a> 
<a class="line" id="055">055</a> <span class="comment">##</span>
<a class="line" id="056">056</a> <span class="comment"># When mathn is required, Fixnum's division and exponentiation are enhanced to</span>
<a class="line" id="057">057</a> <span class="comment"># return more precise values from mathematical expressions.</span>
<a class="line" id="058">058</a> <span class="comment">#</span>
<a class="line" id="059">059</a> <span class="comment">#   2/3*3  # =&gt; 0</span>
<a class="line" id="060">060</a> <span class="comment">#   require 'mathn'</span>
<a class="line" id="061">061</a> <span class="comment">#   2/3*3  # =&gt; 2</span>
<a class="line" id="062">062</a> 
<a class="line" id="063">063</a> <span class='reserved'>class</span> <a class="ident" href="/mri/ident?i=Fixnum">Fixnum</a>
<a class="line" id="064">064</a>   <a class="ident" href="/mri/ident?i=remove_method">remove_method</a> <span class="string">:/
<a class="line" id="065">065</a> 
<a class="line" id="066">066</a>   ##
<a class="line" id="067">067</a>   # +/+ defines</span> the <a class="ident" href="/mri/ident?i=Rational">Rational</a> division <span class='reserved'>for</span> <a class="ident" href="/mri/ident?i=Fixnum">Fixnum</a>.
<a class="line" id="068">068</a>   <span class="comment">#</span>
<a class="line" id="069">069</a>   <span class="comment">#   1/3  # =&gt; (1/3)</span>
<a class="line" id="070">070</a> 
<a class="line" id="071">071</a>   <span class='reserved'>alias</span> / <a class="ident" href="/mri/ident?i=quo">quo</a>
<a class="line" id="072">072</a> 
<a class="line" id="073">073</a>   <span class='reserved'>alias</span> power! ** <span class='reserved'>unless</span> method_defined? <span class="string">:power!</span>
<a class="line" id="074">074</a> 
<a class="line" id="075">075</a>   <span class="comment">##</span>
<a class="line" id="076">076</a>   <span class="comment"># Exponentiate by +other+</span>
<a class="line" id="077">077</a> 
<a class="line" id="078">078</a>   <span class='reserved'>def</span> ** (<a class="ident" href="/mri/ident?i=other">other</a>)
<a class="line" id="079">079</a>     <span class='reserved'>if</span> <span class='reserved'>self</span> &lt; 0 &amp;&amp; <a class="ident" href="/mri/ident?i=other">other</a>.<a class="ident" href="/mri/ident?i=round">round</a> != <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="080">080</a>       <a class="ident" href="/mri/ident?i=Complex">Complex</a>(<span class='reserved'>self</span>, 0.0) ** <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="081">081</a>     <span class='reserved'>else</span>
<a class="line" id="082">082</a>       power!(<a class="ident" href="/mri/ident?i=other">other</a>)
<a class="line" id="083">083</a>     <span class='reserved'>end</span>
<a class="line" id="084">084</a>   <span class='reserved'>end</span>
<a class="line" id="085">085</a> 
<a class="line" id="086">086</a> <span class='reserved'>end</span>
<a class="line" id="087">087</a> 
<a class="line" id="088">088</a> <span class="comment">##</span>
<a class="line" id="089">089</a> <span class="comment"># When mathn is required Bignum's division and exponentiation are enhanced to</span>
<a class="line" id="090">090</a> <span class="comment"># return more precise values from mathematical expressions.</span>
<a class="line" id="091">091</a> 
<a class="line" id="092">092</a> <span class='reserved'>class</span> <a class="ident" href="/mri/ident?i=Bignum">Bignum</a>
<a class="line" id="093">093</a>   <a class="ident" href="/mri/ident?i=remove_method">remove_method</a> <span class="string">:/
<a class="line" id="094">094</a> 
<a class="line" id="095">095</a>   ##
<a class="line" id="096">096</a>   # +/+ defines</span> the <a class="ident" href="/mri/ident?i=Rational">Rational</a> division <span class='reserved'>for</span> <a class="ident" href="/mri/ident?i=Bignum">Bignum</a>.
<a class="line" id="097">097</a>   <span class="comment">#</span>
<a class="line" id="098">098</a>   <span class="comment">#   (2**72) / ((2**70) * 3)  # =&gt; 4/3</span>
<a class="line" id="099">099</a> 
<a class="line" id="100">100</a>   <span class='reserved'>alias</span> / <a class="ident" href="/mri/ident?i=quo">quo</a>
<a class="line" id="101">101</a> 
<a class="line" id="102">102</a>   <span class='reserved'>alias</span> power! ** <span class='reserved'>unless</span> method_defined? <span class="string">:power!</span>
<a class="line" id="103">103</a> 
<a class="line" id="104">104</a>   <span class="comment">##</span>
<a class="line" id="105">105</a>   <span class="comment"># Exponentiate by +other+</span>
<a class="line" id="106">106</a> 
<a class="line" id="107">107</a>   <span class='reserved'>def</span> ** (<a class="ident" href="/mri/ident?i=other">other</a>)
<a class="line" id="108">108</a>     <span class='reserved'>if</span> <span class='reserved'>self</span> &lt; 0 &amp;&amp; <a class="ident" href="/mri/ident?i=other">other</a>.<a class="ident" href="/mri/ident?i=round">round</a> != <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="109">109</a>       <a class="ident" href="/mri/ident?i=Complex">Complex</a>(<span class='reserved'>self</span>, 0.0) ** <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="110">110</a>     <span class='reserved'>else</span>
<a class="line" id="111">111</a>       power!(<a class="ident" href="/mri/ident?i=other">other</a>)
<a class="line" id="112">112</a>     <span class='reserved'>end</span>
<a class="line" id="113">113</a>   <span class='reserved'>end</span>
<a class="line" id="114">114</a> 
<a class="line" id="115">115</a> <span class='reserved'>end</span>
<a class="line" id="116">116</a> 
<a class="line" id="117">117</a> <span class="comment">##</span>
<a class="line" id="118">118</a> <span class="comment"># When mathn is required Rational is changed to simplify the use of Rational</span>
<a class="line" id="119">119</a> <span class="comment"># operations.</span>
<a class="line" id="120">120</a> <span class="comment">#</span>
<a class="line" id="121">121</a> <span class="comment"># Normal behaviour:</span>
<a class="line" id="122">122</a> <span class="comment">#</span>
<a class="line" id="123">123</a> <span class="comment">#   Rational.new!(1,3) ** 2 # =&gt; Rational(1, 9)</span>
<a class="line" id="124">124</a> <span class="comment">#   (1 / 3) ** 2            # =&gt; 0</span>
<a class="line" id="125">125</a> <span class="comment">#</span>
<a class="line" id="126">126</a> <span class="comment"># require 'mathn' behaviour:</span>
<a class="line" id="127">127</a> <span class="comment">#</span>
<a class="line" id="128">128</a> <span class="comment">#   (1 / 3) ** 2            # =&gt; 1/9</span>
<a class="line" id="129">129</a> 
<a class="line" id="130">130</a> <span class='reserved'>class</span> <a class="ident" href="/mri/ident?i=Rational">Rational</a>
<a class="line" id="131">131</a>   <a class="ident" href="/mri/ident?i=remove_method">remove_method</a> <span class="string">:**
<a class="line" id="132">132</a> 
<a class="line" id="133">133</a>   ##
<a class="line" id="134">134</a>   # Exponentiate</span> by +<a class="ident" href="/mri/ident?i=other">other</a>+
<a class="line" id="135">135</a>   <span class="comment">#</span>
<a class="line" id="136">136</a>   <span class="comment">#   (1/3) ** 2 # =&gt; 1/9</span>
<a class="line" id="137">137</a> 
<a class="line" id="138">138</a>   <span class='reserved'>def</span> ** (<a class="ident" href="/mri/ident?i=other">other</a>)
<a class="line" id="139">139</a>     <span class='reserved'>if</span> <a class="ident" href="/mri/ident?i=other">other</a>.<a class="ident" href="/mri/ident?i=kind_of?">kind_of?</a>(<a class="ident" href="/mri/ident?i=Rational">Rational</a>)
<a class="line" id="140">140</a>       other2 = <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="141">141</a>       <span class='reserved'>if</span> <span class='reserved'>self</span> &lt; 0
<a class="line" id="142">142</a>         <span class='reserved'>return</span> <a class="ident" href="/mri/ident?i=Complex">Complex</a>(<span class='reserved'>self</span>, 0.0) ** <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="143">143</a>       <span class='reserved'>elsif</span> <a class="ident" href="/mri/ident?i=other">other</a> == 0
<a class="line" id="144">144</a>         <span class='reserved'>return</span> <a class="ident" href="/mri/ident?i=Rational">Rational</a>(1,1)
<a class="line" id="145">145</a>       <span class='reserved'>elsif</span> <span class='reserved'>self</span> == 0
<a class="line" id="146">146</a>         <span class='reserved'>return</span> <a class="ident" href="/mri/ident?i=Rational">Rational</a>(0,1)
<a class="line" id="147">147</a>       <span class='reserved'>elsif</span> <span class='reserved'>self</span> == 1
<a class="line" id="148">148</a>         <span class='reserved'>return</span> <a class="ident" href="/mri/ident?i=Rational">Rational</a>(1,1)
<a class="line" id="149">149</a>       <span class='reserved'>end</span>
<a class="line" id="150">150</a> 
<a class="line" id="151">151</a>       npd = <a class="ident" href="/mri/ident?i=numerator">numerator</a>.<a class="ident" href="/mri/ident?i=prime_division">prime_division</a>
<a class="line" id="152">152</a>       dpd = <a class="ident" href="/mri/ident?i=denominator">denominator</a>.<a class="ident" href="/mri/ident?i=prime_division">prime_division</a>
<a class="line" id="153">153</a>       <span class='reserved'>if</span> <a class="ident" href="/mri/ident?i=other">other</a> &lt; 0
<a class="line" id="154">154</a>         <a class="ident" href="/mri/ident?i=other">other</a> = -<a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="155">155</a>         npd, dpd = dpd, npd
<a class="line" id="156">156</a>       <span class='reserved'>end</span>
<a class="line" id="157">157</a> 
<a class="line" id="158">158</a>       <span class='reserved'>for</span> elm <span class='reserved'>in</span> npd
<a class="line" id="159">159</a>         elm[1] = elm[1] * <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="160">160</a>         <span class='reserved'>if</span> !elm[1].<a class="ident" href="/mri/ident?i=kind_of?">kind_of?</a>(<a class="ident" href="/mri/ident?i=Integer">Integer</a>) <span class='reserved'>and</span> elm[1].<a class="ident" href="/mri/ident?i=denominator">denominator</a> != 1
<a class="line" id="161">161</a>           <span class='reserved'>return</span> <a class="ident" href="/mri/ident?i=Float">Float</a>(<span class='reserved'>self</span>) ** other2
<a class="line" id="162">162</a>         <span class='reserved'>end</span>
<a class="line" id="163">163</a>         elm[1] = elm[1].<a class="ident" href="/mri/ident?i=to_i">to_i</a>
<a class="line" id="164">164</a>       <span class='reserved'>end</span>
<a class="line" id="165">165</a> 
<a class="line" id="166">166</a>       <span class='reserved'>for</span> elm <span class='reserved'>in</span> dpd
<a class="line" id="167">167</a>         elm[1] = elm[1] * <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="168">168</a>         <span class='reserved'>if</span> !elm[1].<a class="ident" href="/mri/ident?i=kind_of?">kind_of?</a>(<a class="ident" href="/mri/ident?i=Integer">Integer</a>) <span class='reserved'>and</span> elm[1].<a class="ident" href="/mri/ident?i=denominator">denominator</a> != 1
<a class="line" id="169">169</a>           <span class='reserved'>return</span> <a class="ident" href="/mri/ident?i=Float">Float</a>(<span class='reserved'>self</span>) ** other2
<a class="line" id="170">170</a>         <span class='reserved'>end</span>
<a class="line" id="171">171</a>         elm[1] = elm[1].<a class="ident" href="/mri/ident?i=to_i">to_i</a>
<a class="line" id="172">172</a>       <span class='reserved'>end</span>
<a class="line" id="173">173</a> 
<a class="line" id="174">174</a>       <a class="ident" href="/mri/ident?i=num">num</a> = <a class="ident" href="/mri/ident?i=Integer">Integer</a>.<a class="ident" href="/mri/ident?i=from_prime_division">from_prime_division</a>(npd)
<a class="line" id="175">175</a>       <a class="ident" href="/mri/ident?i=den">den</a> = <a class="ident" href="/mri/ident?i=Integer">Integer</a>.<a class="ident" href="/mri/ident?i=from_prime_division">from_prime_division</a>(dpd)
<a class="line" id="176">176</a> 
<a class="line" id="177">177</a>       <a class="ident" href="/mri/ident?i=Rational">Rational</a>(<a class="ident" href="/mri/ident?i=num">num</a>,<a class="ident" href="/mri/ident?i=den">den</a>)
<a class="line" id="178">178</a> 
<a class="line" id="179">179</a>     <span class='reserved'>elsif</span> <a class="ident" href="/mri/ident?i=other">other</a>.<a class="ident" href="/mri/ident?i=kind_of?">kind_of?</a>(<a class="ident" href="/mri/ident?i=Integer">Integer</a>)
<a class="line" id="180">180</a>       <span class='reserved'>if</span> <a class="ident" href="/mri/ident?i=other">other</a> &gt; 0
<a class="line" id="181">181</a>         <a class="ident" href="/mri/ident?i=num">num</a> = <a class="ident" href="/mri/ident?i=numerator">numerator</a> ** <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="182">182</a>         <a class="ident" href="/mri/ident?i=den">den</a> = <a class="ident" href="/mri/ident?i=denominator">denominator</a> ** <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="183">183</a>       <span class='reserved'>elsif</span> <a class="ident" href="/mri/ident?i=other">other</a> &lt; 0
<a class="line" id="184">184</a>         <a class="ident" href="/mri/ident?i=num">num</a> = <a class="ident" href="/mri/ident?i=denominator">denominator</a> ** -<a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="185">185</a>         <a class="ident" href="/mri/ident?i=den">den</a> = <a class="ident" href="/mri/ident?i=numerator">numerator</a> ** -<a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="186">186</a>       <span class='reserved'>elsif</span> <a class="ident" href="/mri/ident?i=other">other</a> == 0
<a class="line" id="187">187</a>         <a class="ident" href="/mri/ident?i=num">num</a> = 1
<a class="line" id="188">188</a>         <a class="ident" href="/mri/ident?i=den">den</a> = 1
<a class="line" id="189">189</a>       <span class='reserved'>end</span>
<a class="line" id="190">190</a>       <a class="ident" href="/mri/ident?i=Rational">Rational</a>(<a class="ident" href="/mri/ident?i=num">num</a>, <a class="ident" href="/mri/ident?i=den">den</a>)
<a class="line" id="191">191</a>     <span class='reserved'>elsif</span> <a class="ident" href="/mri/ident?i=other">other</a>.<a class="ident" href="/mri/ident?i=kind_of?">kind_of?</a>(<a class="ident" href="/mri/ident?i=Float">Float</a>)
<a class="line" id="192">192</a>       <a class="ident" href="/mri/ident?i=Float">Float</a>(<span class='reserved'>self</span>) ** <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="193">193</a>     <span class='reserved'>else</span>
<a class="line" id="194">194</a>       <a class="ident" href="/mri/ident?i=x">x</a> , <a class="ident" href="/mri/ident?i=y">y</a> = <a class="ident" href="/mri/ident?i=other">other</a>.<a class="ident" href="/mri/ident?i=coerce">coerce</a>(<span class='reserved'>self</span>)
<a class="line" id="195">195</a>       <a class="ident" href="/mri/ident?i=x">x</a> ** <a class="ident" href="/mri/ident?i=y">y</a>
<a class="line" id="196">196</a>     <span class='reserved'>end</span>
<a class="line" id="197">197</a>   <span class='reserved'>end</span>
<a class="line" id="198">198</a> <span class='reserved'>end</span>
<a class="line" id="199">199</a> 
<a class="line" id="200">200</a> <span class="comment">##</span>
<a class="line" id="201">201</a> <span class="comment"># When mathn is required, the Math module changes as follows:</span>
<a class="line" id="202">202</a> <span class="comment">#</span>
<a class="line" id="203">203</a> <span class="comment"># Standard Math module behaviour:</span>
<a class="line" id="204">204</a> <span class="comment">#   Math.sqrt(4/9)     # =&gt; 0.0</span>
<a class="line" id="205">205</a> <span class="comment">#   Math.sqrt(4.0/9.0) # =&gt; 0.666666666666667</span>
<a class="line" id="206">206</a> <span class="comment">#   Math.sqrt(- 4/9)   # =&gt; Errno::EDOM: Numerical argument out of domain - sqrt</span>
<a class="line" id="207">207</a> <span class="comment">#</span>
<a class="line" id="208">208</a> <span class="comment"># After require 'mathn', this is changed to:</span>
<a class="line" id="209">209</a> <span class="comment">#</span>
<a class="line" id="210">210</a> <span class="comment">#   require 'mathn'</span>
<a class="line" id="211">211</a> <span class="comment">#   Math.sqrt(4/9)      # =&gt; 2/3</span>
<a class="line" id="212">212</a> <span class="comment">#   Math.sqrt(4.0/9.0)  # =&gt; 0.666666666666667</span>
<a class="line" id="213">213</a> <span class="comment">#   Math.sqrt(- 4/9)    # =&gt; Complex(0, 2/3)</span>
<a class="line" id="214">214</a> 
<a class="line" id="215">215</a> <span class='reserved'>module</span> <a class="ident" href="/mri/ident?i=Math">Math</a>
<a class="line" id="216">216</a>   <a class="ident" href="/mri/ident?i=remove_method">remove_method</a>(<span class="string">:sqrt</span>)
<a class="line" id="217">217</a> 
<a class="line" id="218">218</a>   <span class="comment">##</span>
<a class="line" id="219">219</a>   <span class="comment"># Computes the square root of +a+.  It makes use of Complex and</span>
<a class="line" id="220">220</a>   <span class="comment"># Rational to have no rounding errors if possible.</span>
<a class="line" id="221">221</a>   <span class="comment">#</span>
<a class="line" id="222">222</a>   <span class="comment">#   Math.sqrt(4/9)      # =&gt; 2/3</span>
<a class="line" id="223">223</a>   <span class="comment">#   Math.sqrt(- 4/9)    # =&gt; Complex(0, 2/3)</span>
<a class="line" id="224">224</a>   <span class="comment">#   Math.sqrt(4.0/9.0)  # =&gt; 0.666666666666667</span>
<a class="line" id="225">225</a> 
<a class="line" id="226">226</a>   <span class='reserved'>def</span> <a class="ident" href="/mri/ident?i=sqrt">sqrt</a>(<a class="ident" href="/mri/ident?i=a">a</a>)
<a class="line" id="227">227</a>     <span class='reserved'>if</span> <a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=kind_of?">kind_of?</a>(<a class="ident" href="/mri/ident?i=Complex">Complex</a>)
<a class="line" id="228">228</a>       <a class="ident" href="/mri/ident?i=abs">abs</a> = <a class="ident" href="/mri/ident?i=sqrt">sqrt</a>(<a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=real">real</a>*<a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=real">real</a> + <a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=imag">imag</a>*<a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=imag">imag</a>)
<a class="line" id="229">229</a> <span class="comment">#      if not abs.kind_of?(Rational)</span>
<a class="line" id="230">230</a> <span class="comment">#        return a**Rational(1,2)</span>
<a class="line" id="231">231</a> <span class="comment">#      end</span>
<a class="line" id="232">232</a>       <a class="ident" href="/mri/ident?i=x">x</a> = <a class="ident" href="/mri/ident?i=sqrt">sqrt</a>((<a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=real">real</a> + <a class="ident" href="/mri/ident?i=abs">abs</a>)/<a class="ident" href="/mri/ident?i=Rational">Rational</a>(2))
<a class="line" id="233">233</a>       <a class="ident" href="/mri/ident?i=y">y</a> = <a class="ident" href="/mri/ident?i=sqrt">sqrt</a>((-<a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=real">real</a> + <a class="ident" href="/mri/ident?i=abs">abs</a>)/<a class="ident" href="/mri/ident?i=Rational">Rational</a>(2))
<a class="line" id="234">234</a> <span class="comment">#      if !(x.kind_of?(Rational) and y.kind_of?(Rational))</span>
<a class="line" id="235">235</a> <span class="comment">#        return a**Rational(1,2)</span>
<a class="line" id="236">236</a> <span class="comment">#      end</span>
<a class="line" id="237">237</a>       <span class='reserved'>if</span> <a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=imag">imag</a> &gt;= 0
<a class="line" id="238">238</a>         <a class="ident" href="/mri/ident?i=Complex">Complex</a>(<a class="ident" href="/mri/ident?i=x">x</a>, <a class="ident" href="/mri/ident?i=y">y</a>)
<a class="line" id="239">239</a>       <span class='reserved'>else</span>
<a class="line" id="240">240</a>         <a class="ident" href="/mri/ident?i=Complex">Complex</a>(<a class="ident" href="/mri/ident?i=x">x</a>, -<a class="ident" href="/mri/ident?i=y">y</a>)
<a class="line" id="241">241</a>       <span class='reserved'>end</span>
<a class="line" id="242">242</a>     <span class='reserved'>elsif</span> <a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=respond_to?">respond_to?</a>(<span class="string">:nan?</span>) <span class='reserved'>and</span> <a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=nan?">nan?</a>
<a class="line" id="243">243</a>       <a class="ident" href="/mri/ident?i=a">a</a>
<a class="line" id="244">244</a>     <span class='reserved'>elsif</span> <a class="ident" href="/mri/ident?i=a">a</a> &gt;= 0
<a class="line" id="245">245</a>       <a class="ident" href="/mri/ident?i=rsqrt">rsqrt</a>(<a class="ident" href="/mri/ident?i=a">a</a>)
<a class="line" id="246">246</a>     <span class='reserved'>else</span>
<a class="line" id="247">247</a>       <a class="ident" href="/mri/ident?i=Complex">Complex</a>(0,<a class="ident" href="/mri/ident?i=rsqrt">rsqrt</a>(-<a class="ident" href="/mri/ident?i=a">a</a>))
<a class="line" id="248">248</a>     <span class='reserved'>end</span>
<a class="line" id="249">249</a>   <span class='reserved'>end</span>
<a class="line" id="250">250</a> 
<a class="line" id="251">251</a>   <span class="comment">##</span>
<a class="line" id="252">252</a>   <span class="comment"># Compute square root of a non negative number. This method is</span>
<a class="line" id="253">253</a>   <span class="comment"># internally used by +Math.sqrt+.</span>
<a class="line" id="254">254</a> 
<a class="line" id="255">255</a>   <span class='reserved'>def</span> <a class="ident" href="/mri/ident?i=rsqrt">rsqrt</a>(<a class="ident" href="/mri/ident?i=a">a</a>)
<a class="line" id="256">256</a>     <span class='reserved'>if</span> <a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=kind_of?">kind_of?</a>(<a class="ident" href="/mri/ident?i=Float">Float</a>)
<a class="line" id="257">257</a>       sqrt!(<a class="ident" href="/mri/ident?i=a">a</a>)
<a class="line" id="258">258</a>     <span class='reserved'>elsif</span> <a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=kind_of?">kind_of?</a>(<a class="ident" href="/mri/ident?i=Rational">Rational</a>)
<a class="line" id="259">259</a>       <a class="ident" href="/mri/ident?i=rsqrt">rsqrt</a>(<a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=numerator">numerator</a>)/<a class="ident" href="/mri/ident?i=rsqrt">rsqrt</a>(<a class="ident" href="/mri/ident?i=a">a</a>.<a class="ident" href="/mri/ident?i=denominator">denominator</a>)
<a class="line" id="260">260</a>     <span class='reserved'>else</span>
<a class="line" id="261">261</a>       <a class="ident" href="/mri/ident?i=src">src</a> = <a class="ident" href="/mri/ident?i=a">a</a>
<a class="line" id="262">262</a>       <a class="ident" href="/mri/ident?i=max">max</a> = 2 ** 32
<a class="line" id="263">263</a>       byte_a = [<a class="ident" href="/mri/ident?i=src">src</a> &amp; 0xffffffff]
<a class="line" id="264">264</a>       <span class="comment"># ruby's bug</span>
<a class="line" id="265">265</a>       <span class='reserved'>while</span> (<a class="ident" href="/mri/ident?i=src">src</a> &gt;= <a class="ident" href="/mri/ident?i=max">max</a>) <span class='reserved'>and</span> (<a class="ident" href="/mri/ident?i=src">src</a> &gt;&gt;= 32)
<a class="line" id="266">266</a>         byte_a.<a class="ident" href="/mri/ident?i=unshift">unshift</a> <a class="ident" href="/mri/ident?i=src">src</a> &amp; 0xffffffff
<a class="line" id="267">267</a>       <span class='reserved'>end</span>
<a class="line" id="268">268</a> 
<a class="line" id="269">269</a>       <a class="ident" href="/mri/ident?i=answer">answer</a> = 0
<a class="line" id="270">270</a>       <a class="ident" href="/mri/ident?i=main">main</a> = 0
<a class="line" id="271">271</a>       side = 0
<a class="line" id="272">272</a>       <span class='reserved'>for</span> elm <span class='reserved'>in</span> byte_a
<a class="line" id="273">273</a>         <a class="ident" href="/mri/ident?i=main">main</a> = (<a class="ident" href="/mri/ident?i=main">main</a> &lt;&lt; 32) + elm
<a class="line" id="274">274</a>         side &lt;&lt;= 16
<a class="line" id="275">275</a>         <span class='reserved'>if</span> <a class="ident" href="/mri/ident?i=answer">answer</a> != 0
<a class="line" id="276">276</a>           <span class='reserved'>if</span> <a class="ident" href="/mri/ident?i=main">main</a> * 4  &lt; side * side
<a class="line" id="277">277</a>             applo = <a class="ident" href="/mri/ident?i=main">main</a>.<a class="ident" href="/mri/ident?i=div">div</a>(side)
<a class="line" id="278">278</a>           <span class='reserved'>else</span>
<a class="line" id="279">279</a>             applo = ((sqrt!(side * side + 4 * <a class="ident" href="/mri/ident?i=main">main</a>) - side)/2.0).<a class="ident" href="/mri/ident?i=to_i">to_i</a> + 1
<a class="line" id="280">280</a>           <span class='reserved'>end</span>
<a class="line" id="281">281</a>         <span class='reserved'>else</span>
<a class="line" id="282">282</a>           applo = sqrt!(<a class="ident" href="/mri/ident?i=main">main</a>).<a class="ident" href="/mri/ident?i=to_i">to_i</a> + 1
<a class="line" id="283">283</a>         <span class='reserved'>end</span>
<a class="line" id="284">284</a> 
<a class="line" id="285">285</a>         <span class='reserved'>while</span> (<a class="ident" href="/mri/ident?i=x">x</a> = (side + applo) * applo) &gt; <a class="ident" href="/mri/ident?i=main">main</a>
<a class="line" id="286">286</a>           applo -= 1
<a class="line" id="287">287</a>         <span class='reserved'>end</span>
<a class="line" id="288">288</a>         <a class="ident" href="/mri/ident?i=main">main</a> -= <a class="ident" href="/mri/ident?i=x">x</a>
<a class="line" id="289">289</a>         <a class="ident" href="/mri/ident?i=answer">answer</a> = (<a class="ident" href="/mri/ident?i=answer">answer</a> &lt;&lt; 16) + applo
<a class="line" id="290">290</a>         side += applo * 2
<a class="line" id="291">291</a>       <span class='reserved'>end</span>
<a class="line" id="292">292</a>       <span class='reserved'>if</span> <a class="ident" href="/mri/ident?i=main">main</a> == 0
<a class="line" id="293">293</a>         <a class="ident" href="/mri/ident?i=answer">answer</a>
<a class="line" id="294">294</a>       <span class='reserved'>else</span>
<a class="line" id="295">295</a>         sqrt!(<a class="ident" href="/mri/ident?i=a">a</a>)
<a class="line" id="296">296</a>       <span class='reserved'>end</span>
<a class="line" id="297">297</a>     <span class='reserved'>end</span>
<a class="line" id="298">298</a>   <span class='reserved'>end</span>
<a class="line" id="299">299</a> 
<a class="line" id="300">300</a>   <span class='reserved'>class</span> &lt;&lt; <span class='reserved'>self</span>
<a class="line" id="301">301</a>     <a class="ident" href="/mri/ident?i=remove_method">remove_method</a>(<span class="string">:sqrt</span>)
<a class="line" id="302">302</a>   <span class='reserved'>end</span>
<a class="line" id="303">303</a>   module_function <span class="string">:sqrt</span>
<a class="line" id="304">304</a>   module_function <span class="string">:rsqrt</span>
<a class="line" id="305">305</a> <span class='reserved'>end</span>
<a class="line" id="306">306</a> 
<a class="line" id="307">307</a> <span class="comment">##</span>
<a class="line" id="308">308</a> <span class="comment"># When mathn is required, Float is changed to handle Complex numbers.</span>
<a class="line" id="309">309</a> 
<a class="line" id="310">310</a> <span class='reserved'>class</span> <a class="ident" href="/mri/ident?i=Float">Float</a>
<a class="line" id="311">311</a>   <span class='reserved'>alias</span> power! **
<a class="line" id="312">312</a> 
<a class="line" id="313">313</a>   <span class="comment">##</span>
<a class="line" id="314">314</a>   <span class="comment"># Exponentiate by +other+</span>
<a class="line" id="315">315</a> 
<a class="line" id="316">316</a>   <span class='reserved'>def</span> ** (<a class="ident" href="/mri/ident?i=other">other</a>)
<a class="line" id="317">317</a>     <span class='reserved'>if</span> <span class='reserved'>self</span> &lt; 0 &amp;&amp; <a class="ident" href="/mri/ident?i=other">other</a>.<a class="ident" href="/mri/ident?i=round">round</a> != <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="318">318</a>       <a class="ident" href="/mri/ident?i=Complex">Complex</a>(<span class='reserved'>self</span>, 0.0) ** <a class="ident" href="/mri/ident?i=other">other</a>
<a class="line" id="319">319</a>     <span class='reserved'>else</span>
<a class="line" id="320">320</a>       power!(<a class="ident" href="/mri/ident?i=other">other</a>)
<a class="line" id="321">321</a>     <span class='reserved'>end</span>
<a class="line" id="322">322</a>   <span class='reserved'>end</span>
<a class="line" id="323">323</a> 
<a class="line" id="324">324</a> <span class='reserved'>end</span></pre>
<footer>
  <nav class="buttons">
    <a href="http://validator.w3.org/check/referer"><img src="/images/valid-html5.png" alt="Valid HTML5"></a>
    <a href="http://jigsaw.w3.org/css-validator/check/referer"><img src="/images/valid-css2.png" alt="Valid CSS2"></a>
  </nav>

  This page was automatically generated by the 0.9.9
  <a href="http://lxr.sf.net/">LXR engine</a>.<br>
  <a href="/">Ruby Cross Reference</a> brought to you by
  <a href="mailto:whitequark@whitequark.org">Peter Zotov</a>.
</footer>

<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-25526594-2']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>

<script type="text/javascript">
  var _gauges = _gauges || [];
  (function() {
    var t   = document.createElement('script');
    t.type  = 'text/javascript';
    t.async = true;
    t.id    = 'gauges-tracker';
    t.setAttribute('data-site-id', '502704d6f5a1f54d1e00000e');
    t.src = '//secure.gaug.es/track.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(t, s);
  })();
</script>

</div></body>
</html>
