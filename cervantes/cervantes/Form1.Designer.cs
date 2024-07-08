using Npgsql;
using System.Data;
using System.Windows.Forms;

namespace cervantes
{
    partial class Form1
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.txtCampoTexto = new System.Windows.Forms.TextBox();
            this.txtCampoNumerico = new System.Windows.Forms.TextBox();
            this.btnInserir = new System.Windows.Forms.Button();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // txtCampoTexto
            // 
            this.txtCampoTexto.Location = new System.Drawing.Point(13, 13);
            this.txtCampoTexto.Name = "txtCampoTexto";
            this.txtCampoTexto.Size = new System.Drawing.Size(100, 20);
            this.txtCampoTexto.TabIndex = 0;
            // 
            // txtCampoNumerico
            // 
            this.txtCampoNumerico.Location = new System.Drawing.Point(13, 40);
            this.txtCampoNumerico.Name = "txtCampoNumerico";
            this.txtCampoNumerico.Size = new System.Drawing.Size(100, 20);
            this.txtCampoNumerico.TabIndex = 1;
            // 
            // btnInserir
            // 
            this.btnInserir.Location = new System.Drawing.Point(13, 67);
            this.btnInserir.Name = "btnInserir";
            this.btnInserir.Size = new System.Drawing.Size(75, 23);
            this.btnInserir.TabIndex = 2;
            this.btnInserir.Text = "Inserir";
            this.btnInserir.UseVisualStyleBackColor = true;
            this.btnInserir.Click += new System.EventHandler(this.btnInserir_Click);
            // 
            // dataGridView1
            // 
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(13, 97);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.Size = new System.Drawing.Size(240, 150);
            this.dataGridView1.TabIndex = 3;
            // 
            // Form1
            // 
            this.ClientSize = new System.Drawing.Size(284, 261);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.btnInserir);
            this.Controls.Add(this.txtCampoNumerico);
            this.Controls.Add(this.txtCampoTexto);
            this.Name = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        private System.Windows.Forms.TextBox txtCampoTexto;
        private System.Windows.Forms.TextBox txtCampoNumerico;
        private System.Windows.Forms.Button btnInserir;
        private System.Windows.Forms.DataGridView dataGridView1;
    }


    public partial class Form1 : Form
    {

        private string connectionString = "Host=127.0.0.1;Port=1106;Username=postgres;Password=Luan95866420;Database=my_database";

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            CarregarDados();
        }

        private void CarregarDados()
        {
            using (var conn = new NpgsqlConnection(connectionString))
            {
                conn.Open();
                var cmd = new NpgsqlCommand("SELECT * FROM cadastro", conn);
                var dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                dataGridView1.DataSource = dt;
            }
        }

        private void btnInserir_Click(object sender, EventArgs e)
        {
            var campoTexto = txtCampoTexto.Text;
            var campoNumerico = int.Parse(txtCampoNumerico.Text);

            using (var conn = new NpgsqlConnection(connectionString))
            {
                conn.Open();
                var cmd = new NpgsqlCommand("INSERT INTO cadastro (campo_texto, campo_numerico) VALUES (@campoTexto, @campoNumerico)", conn);
                cmd.Parameters.AddWithValue("campoTexto", campoTexto);
                cmd.Parameters.AddWithValue("campoNumerico", campoNumerico);
                try
                {
                    cmd.ExecuteNonQuery();
                    MessageBox.Show("Registro inserido com sucesso!");
                    CarregarDados();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Erro ao inserir registro: {ex.Message}");
                }
            }
        }
    }
}
