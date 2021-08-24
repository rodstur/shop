import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product_item_provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/utils/validator.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, Object?> _formData = {};
  final validator = Validator();

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //listener para mudança de foco
    _imageUrlFocus.addListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  void _toggleIsLoading() {
    setState(() => _isLoading = !_isLoading);
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    //dismiss keyboard
    FocusScope.of(context).unfocus();

    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

    //invoca os onsave dos elementos do form, salvando o estado
    _formKey.currentState!.save();

    final product = ProductItemProvider(
      id: validator.checkObject(_formData['id']),
      title: _formData['title'].toString(),
      description: _formData['description'].toString(),
      price: double.parse(_formData['price'].toString()),
      imageUrl: _formData['imageUrl'].toString(),
    );

    _toggleIsLoading();

    final sucess = await productsProvider.createOrUpdateProduct(product);

    if (sucess) {
      Navigator.of(context).pop();
      showMessage(context: context, message: 'Product added or updated');
    } else {
      _toggleIsLoading();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
          title: const Text('Error'),
          content: const Text('An error ocurred while processing request'),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var product = ModalRoute.of(context)!.settings.arguments;

    if (_formData.isEmpty && product != null) {
      product = product as ProductItemProvider;
      _populateFormData(product);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
    _imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Form'), actions: [
        IconButton(
          onPressed: () => submitForm(),
          icon: const Icon(Icons.save),
        )
      ]),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _titleField(),
                    _priceField(),
                    _descriptionField(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _imageUrlField(),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(left: 10, top: 10, right: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? const Text('No image')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _titleField() {
    return TextFormField(
      initialValue: validator.checkObject(_formData['title']),
      decoration: const InputDecoration(labelText: 'Title'),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocus),
      onSaved: (value) => _formData['title'] = value,
      validator: (value) => validator.fieldEmptyValidator(value!),
    );
  }

  Widget _priceField() {
    return TextFormField(
      initialValue: validator.checkObject(_formData['price']),
      decoration: const InputDecoration(labelText: 'Price'),
      textInputAction: TextInputAction.next,
      //associando um objeto focus
      focusNode: _priceFocus,
      //teclado numerico
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onFieldSubmitted: (_) {
        //muda o foco para o proximo elemento que possui um obj focus
        FocusScope.of(context).requestFocus(_descriptionFocus);
      },
      validator: (value) => validator.fieldDoubleValidator(value!),
      onSaved: (value) => _formData['price'] = double.parse(value!),
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      initialValue: validator.checkObject(_formData['description']),
      decoration: const InputDecoration(labelText: 'Description'),
      focusNode: _descriptionFocus,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      maxLines: 3,
      onSaved: (value) => _formData['description'] = value,
      validator: (value) => validator.fieldEmptyValidator(value!),
    );
  }

  Widget _imageUrlField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Image URL'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      focusNode: _imageUrlFocus,
      controller: _imageUrlController,
      onSaved: (value) => _formData['imageUrl'] = value,
      onFieldSubmitted: (_) => submitForm(),
      validator: (value) {
        // ignore: unnecessary_raw_strings
        if (!RegExp(r'https?://.+(\.jpg|\.png|\.jpeg|)').hasMatch(value!.trim())) {
          return 'Invalid Url';
        }
        return null;
      },
    );
  }

  void _populateFormData(ProductItemProvider product) {
    _formData['id'] = product.id;
    _formData['title'] = product.title;
    _formData['price'] = product.price;
    _formData['description'] = product.description;
    _formData['imageUrl'] = product.imageUrl;

    _imageUrlController.text = product.imageUrl;
  }

  void showMessage({
    required BuildContext context,
    required String message,
    bool errorMessage = false,
  }) {
    Color? bgColor = Colors.green;
    Color? txtColor;

    if (errorMessage) {
      bgColor = Theme.of(context).errorColor;
      txtColor = Colors.white;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(color: txtColor)),
      backgroundColor: bgColor,
    ));
  }
}
