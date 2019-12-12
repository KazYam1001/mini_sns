$(document).on('turbolinks:load', function(){
  Payjp.setPublicKey('pk_test_9ebaca48cfe1eb60058d9d0a');

  $('#card_submit').on('click', e => {
    e.preventDefault();
    $('#card_submit').prop('disabled', true);
    const card = {
      number: $('#number').val(),
      exp_month: $('#_exp_month_2i').val(),
      exp_year: $('#exp_year').val(),
      cvc: $('#cvc').val(),
    }
    console.log(card)
    Payjp.createToken(card, (status, response) => {
      if (status === 200) {
        // handle token object and send back to your server. You can get token id from "response.id".
        console.log(response)
        alert('トークン発行に成功しました')
        $('#number').removeAttr('name');
        $('#_exp_month_2i').removeAttr('name');
        $('#exp_year').removeAttr('name');
        $('#cvc').removeAttr('name');

        $('#new_card').append(`<input type=hidden name=payjp_token value=${response.id}>`);
        $('#new_card').submit();
      } else {
        // handle error like displaying error message.
        console.log(response)
        alert('トークン発行に失敗しました')
        $('#card_submit').prop('disabled', false);
      };
    });
  })
});
