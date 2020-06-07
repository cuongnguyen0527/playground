## Giới thiệu về file CSV
### CSV là gì
CSV là viết tắt của _**C**omma-**S**eparated **V**alues_, các giá trị tách nhau
bởi dấu phẩy. Mỗi dòng của file là một record (bản ghi), mỗi record có một hay
nhiều field (vùng) tách biệt nhau bởi dấu phẩy. Đó là nguồn gốc của tên định dạng
file này.

### CSV dùng làm gì
Đọc sơ qua thì thấy cấu trúc của file có dạng giống bảng rồi đúng không. Nó
trông có vẻ giống thế này:

```
1,Nam,1995
2,Nu,1997
3,Be De,2000
```

Thế nên CSV thường được dùng để lưu dữ liệu có cấu trúc dạng bảng. Bạn có thể
copy ví dụ ở trên vào một file có tên là `sample.csv` rồi lưu lại sau đó mở bằng
phần mềm Excel và sẽ thấy nó được format đúng theo dạng bảng.

![CSV excel](https://cuongdn.com/images/csv-vd.png " ")

Rất đơn giản đúng không nào? Bạn có thể tự tạo dữ liệu cho file sau đó hiển thị
nó trên Excel để làm việc, tiện lợi ha!

### Đặc điểm file CSV
Theo định nghĩa ban đầu, dấu phẩy được dùng để tách các field, nhưng đặt trường
hợp trong field cũng có kí tự dấu phẩy thì sao? Cho nên không nhất thiết lúc nào
kí tự dùng để ngăn cách là dấu phẩy mà có thể là chấm phẩy, tab,... Ngoài ra để
khắc phục trường hợp trên có thể bọc quanh field bằng dấu ngoặc kép `"`, nhưng
lại nảy sinh trường hợp trong field cũng có dấu ngoặc kép, và cũng lại dẫn tới
những cách giải quyết khác. (Có thể escape [giải thoát] ký tự). Điều đó làm cho
định dạng file CSV không được tiêu chuẩn hoá hoàn chỉnh mà tuỳ theo hoàn cảnh.

Đó là một ít thông tin về CSV, giờ hãy cùng xem thử Ruby có gì để hỗ trợ ta làm
việc với CSV không nhé.

## CSV trong ruby
Ruby có hẳn một thư viện để hỗ trợ ta đọc và viết file CSV, ta chỉ cần gọi
`require 'csv'` là dùng được rồi. Thư viện này cung cấp một giao diện hoàn chỉnh
cho file và data (dữ liệu) CSV, các công cụ của nó cho phép đọc, viết từ string
(chuỗi) hoặc đối tượng IO cùng với đó là việc mã hoá kí tự dùng cho file, ví dụ
như UTF-8, ASCII, UTF-16,...

### Làm quen với API
Chúng ta sẽ cũng làm quen với cách đọc, viết file, và chuyển đổi dữ liệu trong CSV.

#### Đọc file CSV
Ruby cung cấp hàm `read` cho việc đọc. Lấy ví dụ đầu bài với file `sample.csv`. Kể
từ đây các bạn nhớ `require 'csv'` rồi mới dùng nhé!

```ruby
csv = CSV.read("path/to/sample.csv")
# [["1", "Nam", "1995"], ["2", "Nu", "1997"], ["3", "Be De", "2000"]]
```

`read` trả về cho ta một mảng các mảng, mảng con ở đây đại diện cho record của
file. Mỗi field là một một phần tử trong mảng con.

Không chỉ từ file, ruby còn hỗ trợ ta đọc từ string.
```ruby
csv = CSV.parse("ID,Ten,Nam sinh")
# [["ID", "Ten", "Nam sinh"]]
```

Ngoài `read`, `parse` ra còn có các hàm phục vụ cho việc đọc khác như `each`,
`shift`,...
Các bạn nên đọc tài liệu nắm rõ về chúng.

#### Viết file CSV
Tương tự, ta cũng có thể viết ra file hoặc viết ra string.
Dùng hàm `open` để viết ra file, truyền vào tham số là `filename` và thêm biến tuỳ
chọn `mode` (chế độ) theo hàm `open` của Ruby ví dụ như `'rb'` (mặc định), `'wb'`,...
Hàm này sẽ truyền đối tượng CSV vào block để ta có thể thêm vào các hàng.

```ruby
CSV.open("path/to/sample2.csv", "wb") do |csv|
  csv << %w(ten ho tuoi) # để thêm hàng dùng hàm <<
  csv << %w(hang khac)   # tương tự
  # ...
end
```

Với string, ta có hàm `generate`

```ruby
csv = CSV.generate do |csv|
  csv << %w(ten ho tuoi)
  csv << %w(hang khac)
  # ...
end
# "ten,ho,tuoi\nhang,khac\n"
```

Để ý mặc định ngăn cách các hàng bằng kí tự newline `\n`.

#### Tham số `options`
Trong tất cả các hàm được giới thiệu ở trên ta đều có thể truyền thêm tham số
`options`. Biến này dùng để tuỳ biến cho CSV, ví dụ như `col_sep` kí tự dùng để
tách cột - mặc định là `,`, `row_sep` kí tự dùng để tách hàng - mặc định là
`\n`,... có nhiều thứ sẽ giúp ta giải quyết một số vấn đề chuyên biệt nên hãy
đánh dấu lại để về sau cần thì dùng tới nhé.

#### Chuyển đổi dữ liệu
Một thuộc tính trong `options` giúp ta đặt tên cho cột là `:headers`. Nếu khi đọc
file với `:headers` có giá trị `true`, giá trị trả về sẽ là instance (đối tượng)
của `CSV::Table` gồm các `CSV:Row`.

```ruby
csv = "ID,Ten,Nam sinh\n1,Nam,1995\n2,Nu,1997\n3,Be De,2000"
data = CSV.parse(csv, headers: true)
data[1].to_h
# {
#   "ID"       => "2",
#   "Ten"      => "Nu",
#   "Nam sinh" => "1997"
# }
```

Một thuộc tính khác là `:converters` cho phép chuyển đổi dữ liệu đầu vào. Ta có
thể dùng các converter có sẵn lấy từ `CSV::Converters` hoặc truyền vào lambda.

```ruby
CSV::Converters
# :integer
# Chuyển đổi bất cứ field nào mà Integer() hiểu.

# :float
# Chuyển đổi bất cứ field nào mà Float() hiểu.

# :numeric
# A combination of :integer and :float.
# Kết hợp :integer và :float.

# :date
# Chuyển đổi bất cứ field nào mà Date::parse() hiểu.

# :date_time
# Chuyển đổi bất cứ field nào mà DateTime::parse() hiểu.

# :all
# Tất cả converter có sẵn. Kết hợp cả :date_time và :numeric.
```

Nãy giờ các bạn có để ý các field ta nhận được khi parse (phân tích) file CSV luôn
là kiểu string. Ta có thể dùng converter để chuyển nó thành các kiểu mà ta mong
muốn. Ví dụ

```ruby
CSV.parse('1,Nam,1995-03-15', converters: %i[numeric date])
# [[1, "Nam", #<Date: 1995-03-15 ((2449792j,0s,0n),+0s,2299161j)> ]]
# Giá trị đầu tiên kiểu integer, thứ hai
# kiểu string và cuối cùng kiểu date

CSV.parse(
  '1,Nam,1995-03-15',
  converters: [:numeric, ->(v) { v.include?('-') ? v.split('-') : v }]
)
# [[1, "Nam", ["1995", "03", "15"]]]
# Giá trị đầu tiên kiểu integer, thứ hai
# kiểu string và cuối cùng kiểu array
```

Converters giúp ta trong một số trường hợp như sau khi parse bạn muốn truy vấn
hay thêm điều kiện để loại bỏ một số hàng không phù hợp trước khi lưu nó vào
database chẳng hạn. Ví dụ, từ file CSV chỉ lấy những row nào có năm sinh trước
năm 1997.

```ruby
# tạo file csv đơn giản
csv = CSV.generate(headers: true) do |csv|
  csv << %w(name birthyear)
  csv << %w(A 1995)
  csv << %w(B 2000)
end
#=> "name,birthyear\nA,1995\nB,2000\n"

# lấy field có birthyear trước 1997 (A, không lấy B)
CSV.parse(csv, converters: :integer, headers: true)
   .select{|r| r["birthyear"] < 1997 }
#=> [{ "name" => "A", "birthyear" => 1995 }]
```

Chúng ta vừa tìm hiểu những công cụ mà Ruby hỗ trợ chúng ta để xử lý CSV, giờ
đem nó thực hành trong một ứng dụng thực tế xem được không nhé.

## Ứng dụng trong Rails
Source code mình tải lên ở [đây](https://github.com/cuongnguyen0527/playground).

Đầu tiên tạo một repo (kho code) Rails. Ruby phiên bản 2.6.3, Rails phiên bản 6.0.2.2.

```
rails new playground
cd playground
```

Giả dụ ta cần theo dõi các nhân viên của một công ty. Dùng lệnh hỗ trợ từ Rails
ta tạo các file mẫu cho nhân viên, từ model, controller cho đến view. Ta đặt tên
model là Staff có các thuộc tính là `first_name`, `last_name`, `date_of_birth`
và `point`.

```
rails g scaffold Staff first_name:string \
last_name:string date_of_birth:date point:integer

rails db:migrate
```

Ta cần một vài dữ liệu mẫu để tiến hành lẹ hơn. Dùng gem *Faker*.

```ruby
# Trong Gemfile thêm
gem 'faker', :git => 'https://github.com/faker-ruby/faker.git', :branch => 'master'
# Nhớ bundle
```

Ta tạo 20 staff với code trong file `db/seeds.rb`

```ruby
20.times do |i|
  Staff.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65),
    point: Faker::Number.number(digits: 3)
  )
end
```

Chạy lệnh `rails server` sau đó vào thử
[http://localhost:3000/staffs](http://localhost:3000/staffs) nếu hiện lên một
danh sách staff với 20 record là đã ổn rồi đấy. Nào bắt đầu với những ví dụ đơn
giản để nắm những thứ vừa học nhé. 🤩

### Tạo file CSV sau đó gửi file
Nói theo kiểu task sếp giao đó là làm sao cho phép tải một file csv với thông tin của
tất cả staff. Ta cần nghĩ về hướng làm trước tiên. Để tải gì đó về ta cần một đường
dẫn (đặt nó đâu đó trên view), và một action trong controller để xử lý request thông
qua đường dẫn đó. Tiếp ta cần lấy được tất cả thông tin cần tải xuống, rồi dùng những
gì ta mới vừa tìm hiểu để tạo CSV sau đó controller sẽ gửi nó theo response về trình
duyệt dưới dạng file. Đơn giản phải không nào.

1. Tạo route

```ruby
# Trong file config/routes.rb sửa thành
resources :staffs do
  collection do
    get :csv
  end
end
```
Ta sẽ có một cái path thế này để tải file `staffs/csv`.

2. Hiển thị link tải file trên view

```html
<!-- Thêm vào file app/views/staffs/index.html.erb -->
<%= link_to 'Download CSV', csv_staffs_path %>
```

3. Tạo action để xử lý route

Trong model ta sẽ tạo CSV dưới dạng string bằng hàm `to_csv` sau đó gửi về trình duyệt
bằng hàm `send_data` trong controller. Có thể nghĩ tới tình huống là tạo luôn file CSV
rồi dùng hàm `send_file` để trả về, nhưng như thế sẽ lâu và tốn công hơn vì sau khi
tạo file ta phải nhớ xoá nó đi nữa.

```ruby
# Trong app/controllers/staffs_controller.rb thêm
def csv
  send_data Staff.to_csv, filename: 'staffs.csv', type: 'text/csv'
end
```

4. Xử lý data để ra CSV trong model

Trong model ta định nghĩa class method (hàm cho lớp) `to_csv` trả về CSV dưới dạng string.

```ruby
# Trong file app/models/staff.rb
# Require thêm thư viện csv vì mặc định Rails không load sẵn thư viện này
require 'csv'

class Staff < ApplicationRecord
  def self.to_csv
    # Lấy các cột cần thể hiện trong CSV
    columns = %i(id first_name last_name date_of_birth point)
    # Chuyển các header này về chuỗi dễ đọc, hàm này có thể dùng cho i18n
    headers = columns.map { |column| Staff.human_attribute_name column }
    # Dùng hàm generate để tạo CSV dạng string với option headers
    CSV.generate(headers: true) do |csv|
      # Hàng đầu tiên là headers
      csv << headers
      # Lấy tất cả các staff, với mỗi staff ta tạo một hàng cho CSV
      find_each do |staff|
        csv << staff.csv_row(columns)
      end
    end
  end
  # Hàm tạo hàng cho CSV, chỉ việc gọi giá trị đơn giản thôi
  def csv_row(cols)
    cols.map { |col| self[col] }
  end
end
```

Logic khá đơn giản, lấy các column cần xuất, chuyển nó về dạng chữ dễ đọc để
làm headers. Từ các column đó ta gọi hàm tương ứng trên mỗi record để tạo hàng
trên CSV.

Rồi giờ vào trang index thử nhấp vào link **Download CSV** xem thử. Nếu tải được
là thành công giống mình rồi đó, kaka, không được thì liên hệ với mình coi sao nha.
Mở file lên và sản phẩm thế này đây.

![CSV excel 2](https://cuongdn.com/images/csv-vd2.png " ")

Giờ hãy thử thêm một nhân viên người Việt xem sao nhé. Trên trang index nhấp vào
link **New Staff** rồi nhập vào thông tin như sau. First name: Thuận, Last name: Ngô,
Date of birth: 19/05/2016, Point: 215. Lần này thử tải file CSV về xem sao nhé.

```
21  Thu·∫≠n Ng√¥  5/19/2016 215
```

Quào, không thấy Thuận Ngô đâu hết mà thấy chữ gì thế này. Nếu không để ý mà để thế
này là sếp buồn lắm đấy. Tại sao file CSV lại hiển thị không đúng chữ tiếng Việt?
Vì chữ Việt thường được mã hoá bằng UTF-8 nên có thể nghĩ theo hướng là CSV mà
mình tạo ra đây không được mã hoá theo UTF-8. Thử debug xem có đúng không nhé.
Mở rails console lên, chạy lệnh này

```ruby
Staff.to_csv.encoding
#=> #<Encoding:UTF-8>
```

Kết quả là UTF-8. Hừm, vậy nguyên nhân không nằm ở mã hoá đoạn string trả về rồi.
Trong trường hợp này string là input cho Excel, nếu vấn đề không nằm ở input thì
có thể là do Excel khi mở file này lên đã không dùng UTF-8. Bạn phải nói chuyện
cùng một ngôn ngữ thì mới hiểu nhau được. Vì vậy để Excel đọc được mình phải thêm
vào CSV một thứ để Excel nhận dạng và dùng UTF-8 để đọc file, đó là BOM.

Nói sơ qua thì BOM là một kí tự xuất hiện ở đầu nội dung file để báo hiệu cho
chương trình đọc nội dung này một số thứ như thứ tự byte, văn bản này dùng mã
hoá Unicode và dùng bộ mã hoá Unicode nào. Vậy ta cần kí tự BOM nói cho ta biết
file này mã hoá theo UTF-8, và chuỗi kí tự đó là `0xEF,0xBB,0xBF`. Ta thử thêm
vào đầu CSV xem được không nhé.

```ruby
# staff.rb
CSV.generate("\xEF\xBB\xBF", headers: true) do |csv|
```

Hàm `generate` cho phép ta truyền biến string vào, biến này sẽ được đặt ở đầu CSV
và tất cả các string thêm vào sau nó sẽ được mã hoá theo mã hoá của biến này là
UTF-8. Giờ thử tải lại CSV xem sao nhé.

```
21  Thuận Ngô 5/19/2016 215
```

Bravo, ngon lành rồi. Kaka, không chỉ cho tiếng Việt mà nó còn áp dụng cho những
ngôn ngữ khác nữa, Nhật Bản, Thái Lan, Trung Quốc,... miễn là bạn biết bộ mã
hoá và BOM cho nó là được.

Thú vị phải không nào, giờ hãy cũng thử lưu data từ file CSV vào database xem sao
nhé.

### Đọc file CSV sau đó tạo records
Giờ mình sẽ tạo một file CSV mẫu có 3 nhân viên như này

| First name | Last name  | Date of birth | Point|
|:----------:|:----------:|:-------------:|:----:|
|    Leo     | Carprio    |   27/5/1995   |  123 |
|  Jennifer  |   Loren    |   15/8/1969   |  243 |
|     Mav    |    Arthur  |   1/1/2000    |  723 |

Trong view mình cần một nơi để upload file. Mình sẽ đặt form trong trang New Staffs

```html
<!-- staffs/new.html.erb -->
<h2>Import from CSV</h2>
<%= render 'import_form' %>

<!-- staffs/_import_form.html.erb -->
<%= form_with url: import_staffs_path, method: :post, local: true do |form| %>
  <div class="field">
    <%= form.file_field :csv %>
  </div>

  <div class="actions">
    <%= form.submit 'Upload' %>
  </div>
<% end %>
```

Thêm đường dẫn mới để xử lý upload file CSV

```ruby
# routes.rb
resources :staffs do
  collection do
    get :csv
    post :import
  end
end
```

Tạo action `import` trong staffs controller

```rb
def import
  Staff.import_from_csv(params[:csv])
  redirect_to staffs_path, notice: 'Staff was successfully imported.'
end
```

Việc xử lý lưu vào database sẽ được thực hiện bên trong model thông qua hàm
`import_from_csv`

```ruby
def self.import_from_csv(csv)
  rows = CSV.read(csv, headers: true, converters: %i(integer date))
  rows.each do |row|
    data = row.to_h
    Staff.create(
      first_name: data['First name'],
      last_name: data['Last name'],
      date_of_birth: data['Date of birth'],
      point: data['Point']
    )
  end
end
```

Gọi hàm `read` để đọc file CSV, với headers để đặt tên cho dữ liệu, khi lấy sẽ dễ
hiểu hơn, ví như như `data['First name']` để lấy giá trị của first name chẳng hạn.
`read` dùng với `headers` sẽ trả về `CSV::Table` gồm các `CSV:Row`, ta có thể gọi
`each` trên `CSV::Table` để lấy từng hàng. Với mỗi hàng ta lưu vào database theo
giá trị tương ứng. Thử import ta sẽ được như này

![CSV excel 3](https://cuongdn.com/images/csv-vd3.jpeg " ")

## Tổng kết
Yeahhhh, vậy là chúng ta đã cùng nhau tìm hiểu về công cụ mà Ruby hỗ trợ chúng
ta làm việc với CSV, cùng với đó là một vài ví dụ thực tế có thể gặp khi triển
khai dự án Ruby on Rails. Tất nhiên những ví dụ trên đây chỉ là tiền đề để các
bạn vận dụng vào những vấn đề thực tế và phức tạp hơn. Thật là hấp dẫn đúng không
nào. Mong là những kiến thức này phần nào tạo được sự tự tin cho các bạn khi đụng
phải CSV.

Chào thân ái và quyết thắng. 😎
