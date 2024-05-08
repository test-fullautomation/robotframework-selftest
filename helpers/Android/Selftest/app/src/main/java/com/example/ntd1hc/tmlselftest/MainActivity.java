package com.example.ntd1hc.tmlselftest;

import android.content.Intent;
import android.os.CountDownTimer;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.PopupMenu;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.SeekBar;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

public class MainActivity extends AppCompatActivity {

    CheckBox ckb1, ckb2, ckb3, ckb4;
    RadioGroup radioGroup;
    RadioButton radio1, radio2, radio3, radio4;
    Button btnVerify;
    Switch swtBtn;
    ToggleButton toggleBtn;

    Button btnPopUp, btnProgress, btnProject, btnRegister;
    ProgressBar progressBar;
    SeekBar seekBar;
    TextView seekVal;

    Intent  intentRegister, intentListview;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        this.setTitle("Main Screen");

        // Intents definition to change screen
        intentRegister = new Intent(MainActivity.this, RegisterActivity.class);
        intentListview = new Intent(MainActivity.this, ListviewActivity.class);

        // Checkbox
        ckb1 = (CheckBox) findViewById(R.id.checkbox1);
        ckb2 = (CheckBox) findViewById(R.id.checkbox2);
        ckb3 = (CheckBox) findViewById(R.id.checkbox3);
        ckb4 = (CheckBox) findViewById(R.id.checkbox4);
        ckb1.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                if(b){
                    Toast.makeText(MainActivity.this, "checkbox 1: checked", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(MainActivity.this, "checkbox 1: unchecked", Toast.LENGTH_SHORT).show();
                }
            }
        });
        ckb2.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                if(b){
                    Toast.makeText(MainActivity.this, "checkbox 2: checked", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(MainActivity.this, "checkbox 2: unchecked", Toast.LENGTH_SHORT).show();
                }
            }
        });
        ckb3.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                if(b){
                    Toast.makeText(MainActivity.this, "checkbox 3: checked", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(MainActivity.this, "checkbox 3: unchecked", Toast.LENGTH_SHORT).show();
                }
            }
        });
        ckb4.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                if(b){
                    Toast.makeText(MainActivity.this, "checkbox 4: checked", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(MainActivity.this, "checkbox 4: unchecked", Toast.LENGTH_SHORT).show();
                }
            }
        });
        // Radio group
        radio1 = (RadioButton) findViewById(R.id.radio1);
        radio2 = (RadioButton) findViewById(R.id.radio2);
        radio3 = (RadioButton) findViewById(R.id.radio3);
        radio4 = (RadioButton) findViewById(R.id.radio4);
        radioGroup = (RadioGroup) findViewById(R.id.radioGroup);
        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup radioGroup, int i) {
                switch (i){
                    case R.id.radio1:
                        Toast.makeText(MainActivity.this, "select readio 1", Toast.LENGTH_SHORT).show();
                        break;
                    case R.id.radio2:
                        Toast.makeText(MainActivity.this, "select readio 2", Toast.LENGTH_SHORT).show();
                        break;
                    case R.id.radio3:
                        Toast.makeText(MainActivity.this, "select readio 3", Toast.LENGTH_SHORT).show();
                        break;
                    case R.id.radio4:
                        Toast.makeText(MainActivity.this, "select readio 4", Toast.LENGTH_SHORT).show();
                        break;
                }
            }
        });

        // Verify button: show all selections of checkbox and radio
        btnVerify = (Button) findViewById(R.id.btnVerify);
        btnVerify.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Checkbox values
                String selectedCkb = "Selected checkbox(s):";
                if(ckb1.isChecked()){
                    selectedCkb += ckb1.getText() + "\n";
                }
                if(ckb2.isChecked()){
                    selectedCkb += ckb2.getText() + "\n";
                }
                if(ckb3.isChecked()){
                    selectedCkb += ckb3.getText() + "\n";
                }
                if(ckb4.isChecked()){
                    selectedCkb += ckb4.getText() + "\n";
                }

                // Radio value
                String selectedRadio = "\nSelected radio:";
                if(radio1.isChecked()){
                    selectedRadio += radio1.getText();
                }
                if(radio2.isChecked()){
                    selectedRadio += radio2.getText();
                }
                if(radio3.isChecked()){
                    selectedRadio += radio3.getText();
                }
                if(radio4.isChecked()){
                    selectedRadio += radio4.getText();
                }

                Toast.makeText(MainActivity.this, selectedCkb+selectedRadio, Toast.LENGTH_LONG).show();
            }
        });

        // Toggle button
        toggleBtn = (ToggleButton) findViewById(R.id.toggleBtn);
        toggleBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

            }
        });
        toggleBtn.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                if(b){
                    Toast.makeText(MainActivity.this, "Toggle to ON STATE", Toast.LENGTH_SHORT).show();
                }else {
                    Toast.makeText(MainActivity.this, "Toggle to OFF STATE", Toast.LENGTH_SHORT).show();
                }
            }
        });

        // Switch button
        swtBtn = (Switch) findViewById(R.id.swtBtn);
        swtBtn.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                if(b){
                    Toast.makeText(MainActivity.this, "Switch change to ON", Toast.LENGTH_SHORT).show();
                }else {
                    Toast.makeText(MainActivity.this, "Switch change to OFF", Toast.LENGTH_SHORT).show();
                }
            }
        });


        // Seek bar
        seekBar = (SeekBar) findViewById(R.id.seekBar);
        seekVal = (TextView) findViewById(R.id.seekVal);
        seekVal.setText(seekBar.getProgress()+"");
        seekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {
                seekVal.setText(i+"");
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        // Progressbar
        btnProgress = (Button) findViewById(R.id.btnProgress);
        progressBar = (ProgressBar) findViewById(R.id.progressBar);

        btnProgress.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Reset if progress bar is get max value
                int resetVal = progressBar.getProgress();
                if(resetVal>=progressBar.getMax()){
                    resetVal = 0;
                    progressBar.setProgress(resetVal);
                }
                // Countdown 10 seconds
                CountDownTimer countDownTimer = new CountDownTimer(10000, 50) {
                    @Override
                    public void onTick(long l) {
                        int nextVal = progressBar.getProgress()+1;
                        if(nextVal>= progressBar.getMax()){
                            Toast.makeText(MainActivity.this, "Progress is completed", Toast.LENGTH_SHORT).show();
                            this.cancel();
//                            nextVal = 0;
                        }
                        progressBar.setProgress(nextVal);
                    }

                    @Override
                    public void onFinish() {
//                        Toast.makeText(MainActivity.this, "Progress is completed", Toast.LENGTH_SHORT).show();
                    }
                }.start();
            }
        });

        // Change to Project screen
        btnProject = (Button) findViewById(R.id.btnProject);
        btnProject.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(intentListview);
            }
        });

        // Change to Register screen
        btnRegister = (Button) findViewById(R.id.btnRegister);
        btnRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(intentRegister);
            }
        });

        // Pop-up menu
        btnPopUp = (Button) findViewById(R.id.btnPopUp);
        btnPopUp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ShowMenu();
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_listscreen, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.registerMenu:
                startActivity(intentRegister);
                break;
            case R.id.listviewMenu:
                startActivity(intentListview);
                break;
            case R.id.exitMenu:
                finish();
                System.exit(0);
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    private  void ShowMenu(){
        PopupMenu popupMenu = new PopupMenu(this, btnPopUp);
        popupMenu.getMenuInflater().inflate(R.menu.menu_popup, popupMenu.getMenu());
        popupMenu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem menuItem) {
                String selectedMenu = menuItem.getTitle().toString().trim();
                btnPopUp.setText(selectedMenu);
                return false;
            }
        });
        popupMenu.show();
    }
}
