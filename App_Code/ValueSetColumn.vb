Imports Microsoft.VisualBasic
Imports System
Imports System.Linq
Imports System.Web.UI.WebControls
Imports Telerik.Web.UI
Imports system.data

Namespace CustomColumns

    Public Class ValueSetColumn
        Inherits TreeListTemplateColumn
        Private _valueSet As String
        Private ListItems As OrderedDictionary

        Public Property ValueSet As String
            Get
                Return _valueSet
            End Get
            Set(value As String)
                Dim strs As String()
                _valueSet = value
                For Each Str As String In value.Split(",")
                    strs = Str.Split("=")
                    ListItems.Add(strs(0), strs(1))
                Next
            End Set
        End Property
        Public Property DefaultMessage As String

        Public Sub New()
            Me.ListItems = New OrderedDictionary()
            Me.ItemTemplate = New ValueSetTemplate(Me, False)
            Me.EditItemTemplate = New ValueSetTemplate(Me, True)
        End Sub

        Private Class ValueSetTemplate
            Implements IBindableTemplate
            Private owner As ValueSetColumn = Nothing
            Private ddl As RadDropDownList = Nothing
            Private EditAble As Boolean = False

            Public Sub New(owner As ValueSetColumn, EditAble As Boolean)
                Me.EditAble = EditAble
                Me.owner = owner
            End Sub

            Public Function ExtractValues(container As Control) As IOrderedDictionary Implements IBindableTemplate.ExtractValues
                Dim values As New OrderedDictionary()
                values(owner.DataField) = ddl.SelectedItem.Value
                Return values
            End Function

            Public Sub InstantiateIn(container As Control) Implements ITemplate.InstantiateIn
                ddl = New RadDropDownList()
                ddl.Enabled = Me.EditAble
                ddl.MergeStyle(owner.ItemStyle)
                ddl.DefaultMessage = Me.owner.DefaultMessage
                AddHandler ddl.DataBinding, AddressOf DataBinding
                container.Controls.Add(ddl)
            End Sub

            Private Sub DataBinding(ByVal sender As Object, ByVal e As EventArgs)
                Dim item As DropDownListItem
                Dim DDL As RadDropDownList = DirectCast(sender, RadDropDownList)
                Dim container As TreeListEditableItem = DirectCast(DDL.NamingContainer, TreeListEditableItem)
                Dim selectedvalue As String
                If TypeOf Container.DataItem Is DataRowView Then
                    selectedvalue = DirectCast(container.DataItem, DataRowView)(owner.DataField).ToString()
                Else
                    selectedvalue = Me.owner.DefaultInsertValue
                End If
                DDL.Items.Clear()
                For Each ditem In owner.ListItems
                    item = New DropDownListItem(ditem.Key, ditem.Value)
                    item.Selected = (item.Value = selectedvalue)
                    DDL.Items.Add(item)
                Next
            End Sub
        End Class

    End Class


    Public Class GridValueSetColumn
        Inherits GridTemplateColumn
    End Class


End Namespace
