import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final FocusNode _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  bool _isInit = true;

  void _updateImageURL() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty) {
        return;
      }
      if (!_imageUrlController.text.startsWith('http') || !_imageUrlController.text.startsWith('https')) {
        return;
      }
      if (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    if (!_form.currentState.validate()) {
      return;
    }

    _form.currentState.save();

    print(_editedProduct.imageUrl);

    if (_editedProduct.id == null) {
      // Add Product
      Provider.of<Products>(context).addProduct(_editedProduct);
    } else {
      // Update Existing Product
      Provider.of<Products>(context).updateProductByID(_editedProduct.id, _editedProduct);
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageURL);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false).findProductByID(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: value,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter number greater than 0';
                    }
                    return null;
                  }
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descFocusNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a description';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 character long';
                    }
                    return null;
                  }
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      height: 100.0,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (value) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _imageUrlController.text,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          if (!value.startsWith('http') || !value.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')) {
                            return 'Please enter a valid image url';
                          }
                          return null;
                        }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
