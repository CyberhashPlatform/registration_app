import 'package:flutter/material.dart';
import '../blocs/provider.dart';
import '../widgets/profile_picture_widget.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration App'),
      ),
      body: Container(
        margin: EdgeInsets.all(0.0),
        child: ListView(
          children: <Widget>[
            ProfilePictureWidget(),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  nameField(bloc),
                  emailField(bloc),
                  passwordField(bloc),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: profileDisclaimer(),
                  ),
                  ageDropdown(bloc),
                  Divider(
                    color: Colors.grey[900],
                    height: 3.0,
                  ),
                  genderDropdown(),
                  Divider(
                    color: Colors.grey[900],
                    height: 3.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ageAndGenderDisclaimer(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: submitButton(bloc),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nameField(Bloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.name,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Name', labelText: 'Name', errorText: snapshot.error),
          onChanged: bloc.changeName,
        );
      },
    );
  }

  Widget emailField(Bloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.email,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: 'Email', labelText: 'Email', errorText: snapshot.error),
          onChanged: bloc.changeEmail,
        );
      },
    );
  }

  Widget passwordField(Bloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.password,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              errorText: snapshot.error),
          obscureText: true,
          onChanged: bloc.changePassword,
        );
      },
    );
  }

  Widget profileDisclaimer() {
    return Text(
        'Your name will be public and we\'ll send updates to the email address you provide');
  }

  // TODO: Update 'value' when snapshot in 'onChanged' is updated.
  Widget ageDropdown(Bloc bloc) {
    String currentItemSelected = 'Age';

    return StreamBuilder<List<String>>(
      stream: bloc.age,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentItemSelected,
            items: snapshot.data.map((itemSnapshot) {
              return DropdownMenuItem<String>(
                value: itemSnapshot,
                child: Text(itemSnapshot),
              );
            }).toList(),
            hint: Text('Enter your age'),
            onChanged: (value) {
              // Update the state
              bloc.items.indexOf(value, 0);
              bloc.fetchItems();
              print(value);
              bloc.changeAge(value);
            },
          ),
        );
      },
    );
  }

  Widget genderDropdown() {
    List<String> genders = ['Male', 'Female', 'None'];
    String currentItemSelected = 'None';

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentItemSelected,
        items: genders.map((String dropdownItems) {
          return DropdownMenuItem<String>(
            value: dropdownItems,
            child: Text(dropdownItems),
          );
        }).toList(),
        hint: Text('Enter a gender'),
        onChanged: (String value) {
          currentItemSelected = value;
          print(currentItemSelected);
        },
      ),
    );
  }

  Widget ageAndGenderDisclaimer() {
    return Text(
        'Age and gender help improve recommendations but are not shown publicly.');
  }

  Widget submitButton(Bloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.submitValid,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return RaisedButton(
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          color: Colors.blue,
          onPressed: snapshot.hasData ? bloc.registerUser : null,
        );
      },
    );
  }
}
