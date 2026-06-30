module QrHelper
  def vietqr_url(bank_code:, account_no:, account_name:, amount: nil, desc: nil)
    url = "https://img.vietqr.io/image/#{bank_code}-#{account_no}-compact2.png"

    params = {}
    params[:amount] = amount if amount
    params[:addInfo] = desc if desc
    params[:accountName] = account_name if account_name

    "#{url}?#{params.to_query}"
  end

  def tuition_status_text(status)
    case status
    when "new"
      "Chưa cọc"
    when "deposit"
      "Chưa thanh toán hết"
    when "payed"
      "Đã thanh toán xong"
    else
      "Không xác định"
    end
  end

end

