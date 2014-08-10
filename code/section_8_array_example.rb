
# Require only one of these, comment out the other:
# require './setup_local_section_8_api'
require './setup_remote_section_8_api'


commit {
  
# ==============================
# Create a containment tree
# This is being done bottom-up for convenience, treating associations like attributes
# Once superior_object_instance is used, it will be necessary to construct the tree top-down
# ==============================

puts "Create containment tree"

result = CMDISE.create(:anything, 'Numeric', :ignored, :ignored, [[:label_string, 'HR']])
puts result.inspect
channel_1_metric = result.object_instance

# Was it the intention to let you set associations during 'set' or using 'create' attributes?  I'm guessing that's only seen as being done using superior_object_instance
result = CMDISE.create('anything', 'Channel', :ignored, :ignored, [[:logical_channel_no, 1], [:physical_channel_no, 1], [:label_string, 'ECG'], [:metric, [channel_1_metric]]])
puts result.inspect
channel_1 = result.object_instance

puts "Channel 1 id: #{channel_1.id.inspect}" # The id is set when the commit closes
puts "Channel 1 logical_channel_no: #{channel_1.logical_channel_no.inspect}" # The other attributes are set
puts "Channel 1 physical_channel_no: #{channel_1.physical_channel_no.inspect}"
puts "Channel 1 label_string: #{channel_1.label_string.inspect}"
puts "Channel 1 metric: #{channel_1.metric.inspect}"

# Look up existing instance. :common_term 'NIBP_SYSTOLIC' did not exist in RTMMS, so I used 'MDC_PRESS_BLD_NONINV_SYS_CTS'
# Section 8 does not include this functionality.  Also we are finding a Coded_term, an instance of an RTMMS class rather than DIM class.
attr_1_id = CMDISE.lookup('Rtmms::Coded_term', :reference_id => 'MDC_PRESS_BLD_NONINV_SYS_CTS')
result = CMDISE.create(1234, 'AVA_Type', :ignored, :ignored, [[:attribute_id_dim, attr_1_id]])
puts result.inspect
attr_1 = result.object_instance
result = CMDISE.create(:anything, 'CmplxObsElem', :ignored, :ignored, [[:cm_elem_idx, 1], [:attributes, [attr_1]]])
puts result.inspect
cm_elem_1 = result.object_instance

attr_2_id = CMDISE.lookup('Rtmms::Coded_term', :reference_id => 'MDC_PRESS_BLD_DIA') # ':common_term NIBP_DIASTOLIC' not in RTMMS
result = CMDISE.create(5678, 'AVA_Type', :ignored, :ignored, [[:attribute_id_dim, attr_2_id]])
puts result.inspect
attr_2 = result.object_instance
result = CMDISE.create(:anything, 'CmplxObsElem', :ignored, :ignored, [[:cm_elem_idx, 2], [:attributes, [attr_2]]])
puts result.inspect
cm_elem_2 = result.object_instance

attr_3_id = CMDISE.lookup('Rtmms::Coded_term', :reference_id => 'MDC_PRESS_BLD_MEAN') # :common_term 'NIBP_MEAN' not in RTMMS
result = CMDISE.create(:anything, 'AVA_Type', :ignored, :ignored, [[:attribute_id_dim, attr_3_id]])
puts result.inspect
attr_3 = result.object_instance
result = CMDISE.create(:anything, 'CmplxObsElem', :ignored, :ignored, [[:cm_elem_idx, 3], [:attributes, [attr_3]]])
puts result.inspect
cm_elem_3 = result.object_instance

result = CMDISE.create(:anything, 'CmplxObsValue', :ignored, :ignored, [[:cm_obs_cnt, 3], [:cm_obs_elem_list, [cm_elem_1, cm_elem_2, cm_elem_3]]])
puts result.inspect
cmplx_obs_val = result.object_instance

result = CMDISE.create(:anything, 'Complex_Metric', :ignored, :ignored, [[:cmplx_recursion_depth, 0], [:max_delay_time, 0], [:label_string, 'NIBP'], [:cmplx_observed_value, cmplx_obs_val]])
puts result.inspect
channel_2_metric = result.object_instance

result = CMDISE.create(:anything, 'Channel', :ignored, :ignored, [[:logical_channel_no, 2], [:physical_channel_no, 2], [:label_string, 'NIBP'], [:metric, [channel_2_metric]]])
puts result.inspect
channel_2 = result.object_instance

result = CMDISE.create(:anything, 'Numeric', :ignored, :ignored, [[:label_string, 'RR']])
puts result.inspect
channel_3_metric = result.object_instance

result = CMDISE.create(:anything, 'Channel', :ignored, :ignored, [[:logical_channel_no, 3], [:physical_channel_no, 1], [:label_string, 'RESP'], [:metric, [channel_3_metric]]])
puts result.inspect
channel_3 = result.object_instance

result = CMDISE.create(:anything, 'Numeric', :ignored, :ignored, [[:label_string, 'PR']])
puts result.inspect
channel_4_metric_1 = result.object_instance

result = CMDISE.create(:anything, 'Numeric', :ignored, :ignored, [[:label_string, 'SpO2R']])
puts result.inspect
channel_4_metric_2 = result.object_instance

result = CMDISE.create(:anything, 'Channel', :ignored, :ignored, [[:logical_channel_no, 4], [:physical_channel_no, 3], [:label_string, 'PLETH'], [:metric, [channel_4_metric_1, channel_4_metric_2]]])
puts result.inspect
channel_4 = result.object_instance

result = CMDISE.create(:anything, 'VMD', :ignored, :ignored, [[:label_string, 'VITALS'], [:channel, [channel_1, channel_2, channel_3, channel_4]]])
puts result.inspect
vmd = result.object_instance

result = CMDISE.create(:anything, 'Simple_MDS', :ignored, :ignored, [[:bed_label, 'DEMO_BED'], [:vmd, [vmd]]])
puts result.inspect
simple_mds = result.object_instance

$CHANNEL_1 = channel_1
$CHANNEL_1_ID = channel_1.id

}

commit {
puts "$CHANNEL_1_ID = #{$CHANNEL_1_ID.inspect}" # The channel did not have an id before the completion of the commit
puts "$CHANNEL_1 = #{$CHANNEL_1.inspect}" # The channel does have an id after the first commit has completed
$CHANNEL_1_ID = $CHANNEL_1.id
# Alternatively, we could look up the channel and get the id
# $CHANNEL_1_ID = CMDISE.lookup('Channel', :logical_channel_no => 1, :physical_channel_no => 1).id
}
raise "Missing $CHANNEL_1_ID" unless $CHANNEL_1_ID


commit {
  
# ==============================
# Modify channel 1 and then get the modified result
# ==============================

puts "\nModify channel 1 and then get the modified result"

puts "\nBefore"
result = CMDISE.get('anything', 'Channel', $CHANNEL_1_ID, [:logical_channel_no, :physical_channel_no, :label_string, :metric])
puts result.inspect

channel_2_metric = CMDISE.lookup('Complex_Metric', :label_string => 'NIBP')

puts "\nSet"
# After we replace the channel 1 metric by the channel 2 metric, channel 2 will no longer have a metric.
# If we didn't want that, we'd replace the channel 1 metric by a brand new metric.
result = CMDISE.set('anything', :ignored, 'Channel', $CHANNEL_1_ID,  [['replace', :logical_channel_no, 27],  ['replace', :physical_channel_no, 99], ['replace', :label_string, 'EEG'],  ['replace', :metric, [channel_2_metric]]])
puts result.inspect

}


commit {

puts "\nAfter"
result = CMDISE.get('anything', 'Channel', $CHANNEL_1_ID, [:logical_channel_no, :physical_channel_no, :label_string, :metric])
puts result.inspect

puts "\nChannel 1 metric (should contain previous channel 2 metric): #{$CHANNEL_1.metric.inspect}"

# The metric will be missing, since we moved it to channel 1
puts "\nChannel 2 metric (should be empty): #{CMDISE.lookup('Channel', :logical_channel_no => 2, :physical_channel_no => 2).metric.inspect}"

}

commit {
  
# ==============================
# Delete old channel 2 metric (now used by channel 1) and then get the modified result
# ==============================

id = $CHANNEL_1.metric[0].id

puts "\nRemove"
result = CMDISE.delete('anything', 'Complex_Metric', id)
puts result.inspect

}

commit {

puts "\nChannel 1 metric (should now be empty): #{$CHANNEL_1.metric.inspect}"
# Or, if you prefer,
puts CMDISE.get('anything', 'Channel', $CHANNEL_1_ID, [:metric]).attribute_list[0].inspect

}

commit {

puts "\nAdd a new VMD"

result = CMDISE.create(:anything, 'VMD', :ignored, :ignored, [[:label_string, 'OTHER']])
puts result.inspect
other_vmd = result.object_instance

simple_mds = CMDISE.lookup('Simple_MDS', :bed_label => 'DEMO_BED')

result = CMDISE.set('anything', :ignored, 'Simple_MDS', simple_mds.id, [['addValues', :vmd, other_vmd]])
puts result.inspect

}

commit {

other_vmd = CMDISE.lookup('VMD', :label_string => 'OTHER')

simple_mds = CMDISE.lookup('Simple_MDS', :bed_label => 'DEMO_BED')

puts simple_mds.vmd.inspect # using the distributed object API instead of 'get'

puts "\nRemove the previously added VMD"

result = CMDISE.set('anything', :ignored, 'Simple_MDS', simple_mds.id, [['removeValues', :vmd, other_vmd]])
puts result.inspect

}

commit {

simple_mds = CMDISE.lookup('Simple_MDS', :bed_label => 'DEMO_BED')

puts simple_mds.vmd.inspect # using the distributed object API instead of 'get'

}