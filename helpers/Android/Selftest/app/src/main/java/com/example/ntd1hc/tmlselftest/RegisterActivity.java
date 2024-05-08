package com.example.ntd1hc.tmlselftest;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

public class RegisterActivity extends AppCompatActivity {

    TextView firstName, lastName, user, password, cfmPass, email, phone;
    Button btnRegister;
    RadioGroup sex;
    RadioButton male, female;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);
        this.setTitle("Register Form");

        mapping();

        // input user event
        user.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                checkRequiredFields();
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });

        // input password event
        password.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                checkRequiredFields();
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
        cfmPass.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                checkRequiredFields();
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });


        btnRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (acceptedPassword()){
                    AlertDialog.Builder  alertDialog = new AlertDialog.Builder(RegisterActivity.this);
                    alertDialog.setTitle("ESY-TML");
                    alertDialog.setMessage("Hi "+ user.getText().toString() +"!\nThank you for registration.");
                    alertDialog.setPositiveButton("OK", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            Intent intent = new Intent(RegisterActivity.this, MainActivity.class);
                            startActivity(intent);
                        }
                    });
                    alertDialog.show();
                } else {
                    Toast.makeText(RegisterActivity.this, "Password is not matched!", Toast.LENGTH_SHORT).show();
                    password.setText("");
                    cfmPass.setText("");
                }
            }
        });
    }

    private void mapping(){
        firstName   = (TextView) findViewById(R.id.firstName);
        lastName    = (TextView) findViewById(R.id.lastName);
        user        = (TextView) findViewById(R.id.userID);
        password    = (TextView) findViewById(R.id.password);
        cfmPass     = (TextView) findViewById(R.id.confirmPassword);
        email       = (TextView) findViewById(R.id.email);
        phone       = (TextView) findViewById(R.id.phone);

        btnRegister = (Button) findViewById(R.id.btnRegister);
        sex         = (RadioGroup) findViewById(R.id.sex);
    }

    private void enableBtn(){
        btnRegister.setBackgroundColor(Color.CYAN);
        btnRegister.setEnabled(true);
    }

    private void disableBtn(){
        btnRegister.setBackgroundColor(Color.rgb(181,181,181));
        btnRegister.setEnabled(false);
    }

    private boolean acceptedPassword(){
        return (password.getText().toString().equals(cfmPass.getText().toString()));
    }

    private void checkRequiredFields(){
        if( !user.getText().toString().trim().isEmpty() &&
            !password.getText().toString().trim().isEmpty() &&
            !cfmPass.getText().toString().trim().isEmpty()){
            enableBtn();
        } else {
            disableBtn();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_back, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()){
            case R.id.menuBack:
                this.finish();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }
}
