// create the signature entry box
var member_sig_canvas = document.getElementById("member_sig");
var witness_sig_canvas = document.getElementById("witness_sig");
var member_sig_pad = new SignaturePad(member_sig_canvas);
var witness_sig_pad = new SignaturePad(witness_sig_canvas);

function submitWaiver() {
  if(member_sig_pad.isEmpty() || witness_sig_pad.isEmpty()) {
    alert("Please sign before submitting your waiver.");
    return false;
  }
  member_field = document.getElementById("member_username");
  if(member_field.value == "") {
    alert("Please enter the member name before submitting your waiver.");
    return false;
  }
  witness_field = document.getElementById("witness_username");
  if(witness_field.value == "") {
    alert("Please enter the witness name before submitting your waiver.");
    return false;
  }
  document.getElementById("member_sigdata").value = member_sig_pad.toDataURL();
  document.getElementById("witness_sigdata").value = witness_sig_pad.toDataURL();
  return true;
}

