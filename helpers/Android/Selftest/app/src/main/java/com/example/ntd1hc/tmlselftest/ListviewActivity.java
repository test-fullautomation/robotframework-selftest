package com.example.ntd1hc.tmlselftest;

import android.app.Dialog;
import android.content.DialogInterface;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;

public class ListviewActivity extends AppCompatActivity {

    ListView listView;
    ArrayList<String> arrProjectList;
    ArrayAdapter adapter;
    FloatingActionButton addBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_listview);
        this.setTitle("Project List");

        listView = (ListView) findViewById(R.id.listview);
        arrProjectList = new ArrayList<>();
        createProjectList();

        addBtn = (FloatingActionButton) findViewById(R.id.addBtn);

        adapter = new ArrayAdapter(this, android.R.layout.simple_list_item_1, arrProjectList);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                String clickProject = arrProjectList.get(i).toString();
                Toast.makeText(ListviewActivity.this, "This is "+clickProject+" project.", Toast.LENGTH_SHORT).show();
            }
        });

        listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, int i, long l) {
                confirmDel(i);
                return false;
            }
        });

        addBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                addProject();
            }
        });
    }

    private void addProject(){
        final Dialog dialog = new Dialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.addproject);
        dialog.setCanceledOnTouchOutside(true);

        Button addProjectBtn = (Button) dialog.findViewById(R.id.addProjectBtn);
        final TextView projectName = (TextView) dialog.findViewById(R.id.inputProjectName);


        addProjectBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String name = projectName.getText().toString().trim();
                if(name.isEmpty()){
                    Toast.makeText(ListviewActivity.this, "Project should not be empty!", Toast.LENGTH_SHORT).show();
                }else {
                    arrProjectList.add(name);
                    adapter.notifyDataSetChanged();
                }
                dialog.cancel();
            }
        });

        dialog.show();
    }

    private void confirmDel(final int position){
        AlertDialog.Builder alertDialog = new AlertDialog.Builder(this);
        alertDialog.setTitle("Confirmation!");
        alertDialog.setIcon(R.mipmap.ic_launcher);
        alertDialog.setMessage("Do you really want to delete this item?");

        alertDialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                Toast.makeText(ListviewActivity.this, "Removed "+arrProjectList.get(position), Toast.LENGTH_SHORT).show();
                arrProjectList.remove(position);
                adapter.notifyDataSetChanged();
            }
        });
        alertDialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {

            }
        });

        alertDialog.show();
    }

    private void createProjectList(){
        arrProjectList.add("Cherry");
        arrProjectList.add("RN-AIVI");
        arrProjectList.add("PSA");
        arrProjectList.add("G3g");
        arrProjectList.add("SUZUKI");
        arrProjectList.add("GM");
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
