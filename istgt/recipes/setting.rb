#
# example
#
#istgt_portal "PortalGroup1" do
#  addresses %w{
#    X.X.X.X:3260
#  }
#end
#
#istgt_initiator "InitiatorGroup1" do
#  initiator_name "iqn.1991-05.com.microsoft:example"
#end
#
#istgt_auth "AuthGroup1" do
#  initiator_name "iqn.1991-05.com.microsoft:example"
#  secret         "example"
#end
#
#istgt_auth "AuthGroup100" do
#  initiator_name "ctluser"
#  secret         "example"
#  mutualuser     "mutualuser"
#  mutualsecret   "mutualsecret"
#  comment        "Unit Controller Users"
#end
#
#istgt_lunit "LogicalUnit1" do
#  target_name "example"
#  mapping     "PortalGroup1 InitiatorGroup1"
#  auth_group  "AuthGroup1"
#  luns        [
#    "Storage /dev/zvol/tank/istgt-vol1 Auto",
#  ]
#end
