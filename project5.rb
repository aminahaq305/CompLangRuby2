# Amina Haq | Project 5 | Writing Iterators in Ruby

#start of class definition for BST
class BST
  attr_reader :compare_method, :count, :head

  #Nested class node, which defines the data type node in each BST
  class Node
    attr_reader :value, :left, :right
    
    #each node has a value, a left pointer, and a right pointer. Value is passed by user
    def initialize(value)
      @value = value
      @left = nil
      @right = nil
    end

    #insert function inserts a newvalue using recursion 
    #and the compare_method defined by the user (or <=> by default)
    def insert(newvalue, func)
      if func.call(newvalue, @value) == -1 #if the value to be inserted is less than the current node's value
        #insert on left subtree
        @left.nil? ? @left = Node.new(newvalue) : @left.insert(newvalue, func) #if the value to be inserted is greater than or equal to the current node's value
        #insert on right subtree
      elsif func.call(newvalue, @value) >= 0
        @right.nil? ? @right = Node.new(newvalue) : @right.insert(newvalue, func)
      end
    end
    
    #converts subtree into an ordered array using inorder traversal logic
    def to_a
      @left.to_a + [@value] + @right.to_a
    end
  end

  #the BST contains of a head pointer, a count variable to keep track of number of nodes in the tree (i.e. size)
  #it also accepts a block of code which is used for comparison throughout the class definition
  def initialize(&block)
    @head = nil
    @count = 0
    #if a block is provided, set the compare_method to that block
    #otherwise set if to Ruby's <=> function defined in public method comparator
    @compare_method = if block_given?
                        block
                      else
                        method(:comparator)
                      end
  end
  
  #function that adds a new item to the tree
  #uses the compare_method provided by user, or <=> by default
  def add(item)
    #if the tree is empty, add the item to the head
    if @head.nil?
      @head = Node.new(item)
    else
      #otherwise, add recursively using insert function defined in node class
      @head.insert(item, @compare_method)
    end
    #increment count to keep track of size
    @count += 1
  end
  
  #if count is 0, BST is empty
  def empty?
    if (@count == 0)
      true
    else
      false
    end
  end
  
  #checks whether the BST, contains a certain item
  #uses helper function search
  def include?(item)
    if @head.nil?
      false
    else
      search(item, @head)
    end
  end
  
  #helper function for include?
  #uses compare_method to decide which subtree might contain the value thus complexity O(log2 n)
  #recursively searches each subtree
  def search(val, node)
    return false if node.nil? #if the node is empty, return false

    case @compare_method.call(val, node.value)
    when -1
      search(val, node.left) #if value is less than the current node, search in left subtree
    when 1
      search(val, node.right) #if value is greater than the current node, search in right subtree
    else
      true #if values are equal, return true
    end
  end
  
  #returns count which holds the number of nodes in the tree
  def size
    @count
  end
 
  #performs an inorder traversal of the BST recursively
  #returns each value/item found to the block provided
  def each_inorder(node = @head, &block)
    return if node.nil?

    each_inorder(node.left, &block)
    yield node.value
    each_inorder(node.right, &block)
  end

  #creates a new BST, which contains the current BSTs items in inorder order
  #uses helper function intraverse and passes it the new BST
  #returns a BST
  def collect_inorder(&block)
    newBST = BST.new()
    intraverse(newBST, &block)
    newBST
  end
  
  #performs inorder traversal recursively and adds each value found to the newBST passed
  def intraverse(newBST, node = @head, &block)
    return if node.nil?

    intraverse(newBST, node.left, &block)
    newBST.add(yield node.value)
    intraverse(newBST, node.right, &block)
  end
  
  #converts the BST to a sorted array
  def to_a
    if @head.nil? #if BST is empty, return empty array
      []
    else
      @head.to_a #otherwise, convert the BST to an array using the to_a function defined in the node class
    end
  end
  
  #returns a deep copy of the BST
  #creates a new array and uses helper function traverse
  def dup 
    newBST = BST.new()
    if @head.nil? #if the current BST is empty, return an empty BST
      return newBST
    else
      traverse(newBST, @head) #otherwise pass the new BST and head pointer of current BST to helper function
    end
    newBST
  end

 #performs preorder traversal recursively
 #adds each value found to the new BST which is a deep copy
  def traverse(myBST, node)
    return if node.nil?

    myBST.add(node.value)
    traverse(myBST, node.left)
    traverse(myBST, node.right)
  end

end

#default compare_method using <=>
def comparator(val1, val2)
  val1 <=> val2
end

