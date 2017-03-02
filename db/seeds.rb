# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

products = Product.create([
    {title: 'BOSE QuietComfort 35', description: '静情聆听 细致心跳', image_url: 'https://making-photos.b0.upaiyun.com/photos/2b85518b63baa3bd4627e86d339b2f89.jpg!middle', price: 399.99},
    {title: 'Nespresso Gran Maestria XN8105', description: '雀巢家用全自动胶囊咖啡机', image_url: 'https://making-photos.b0.upaiyun.com/photos/4ff4e4546a046b24c0f76161a1275b5f.jpg!middle', price: 499},
    {title: 'MUJI 高靠背斜倚沙发', description: '出品：躺着的艺术', image_url: 'https://making-photos.b0.upaiyun.com/photos/9c2a3d9b3ba0a5370960f775d1f12008.jpg!middle', price: 5500},
    {title: 'klhip Nail Clipper', description: '世界上最好用的指甲钳', image_url: 'https://making-photos.b0.upaiyun.com/photos/86146b2ae154e639801bf4ad2fe0999c.jpg!middle', price: 499}
])