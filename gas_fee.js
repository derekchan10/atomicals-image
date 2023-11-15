function gas_fee(end_tx) {
    let value = 0;
    let i = 0;

    try {
        document.querySelectorAll('.tx-page-container').forEach(function (val) {

            tx1 = val.querySelector('.tx-link > app-truncate > span > span.first').innerHTML.replace(' ', '');
            tx2 = val.querySelector('.tx-link > app-truncate > span > span.last-four').innerHTML.replace(' ', '');

            tx = tx1 + tx2;

            let usd = val.nextElementSibling.querySelector('div.summary > div.float-right > button > app-amount > span').innerHTML.replace(' ', '');

            if (usd[0] == '-') {
                value += parseFloat(usd.replace('-US$', '').replace(',', ''));
                console.log(tx, usd, usd[0] == '-');
                i += 1;
            }
            if (tx == end_tx) {
                throw new Error("Found")
            }
        })
    } catch (e) {
        console.log(e.message)
    }


    console.log("金额(U):", Math.round(value), "总张数:", i);
}

gas_fee("最开始的tx")